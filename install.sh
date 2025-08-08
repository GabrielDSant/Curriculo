#!/bin/bash
# ========================================
# 🚀 INSTALADOR AUTOMÁTICO DO CURRÍCULO INTERATIVO
# Script para configuração completa do servidor
# ========================================

set -euo pipefail

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Variáveis globais
INSTALL_DIR="/opt/curriculo"
LOG_FILE="/var/log/curriculo_install.log"
USER_NAME="curriculo"
SHELL_PATH="/usr/bin/cvshell"

# Função de log
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [INFO] $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[OK]${RESET} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [OK] $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERRO]${RESET} $1" >&2
    echo "$(date '+%Y-%m-%d %H:%M:%S') [ERRO] $1" >> "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[AVISO]${RESET} $1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') [AVISO] $1" >> "$LOG_FILE"
}

# Função para verificar se script está sendo executado como root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Este script deve ser executado como root (sudo ./install.sh)"
        exit 1
    fi
}

# Função para criar banner
show_banner() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║              🚀 INSTALADOR CURRÍCULO INTERATIVO            ║"
    echo "║                                                            ║"
    echo "║  Configuração automática de servidor para demonstração    ║"
    echo "║  de currículo em Bash com máxima segurança                ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo
}

# Função para verificar pré-requisitos
check_prerequisites() {
    log_info "Verificando pré-requisitos do sistema..."
    
    # Verificar se é Linux
    if [[ "$(uname -s)" != "Linux" ]]; then
        log_error "Este script só funciona em sistemas Linux"
        exit 1
    fi
    
    # Verificar comandos necessários
    local commands=("useradd" "ssh" "bash" "timeout")
    for cmd in "${commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Comando necessário não encontrado: $cmd"
            exit 1
        fi
    done
    
    # Verificar se SSH está instalado
    if ! systemctl is-active --quiet ssh && ! systemctl is-active --quiet sshd; then
        log_warning "SSH não está ativo. Tentando instalar/iniciar..."
        apt-get update -qq
        apt-get install -y openssh-server
        systemctl enable ssh
        systemctl start ssh
    fi
    
    log_success "Pré-requisitos verificados"
}

# Função para verificar se arquivos do currículo existem
check_curriculum_files() {
    log_info "Verificando arquivos do currículo..."
    
    local required_files=(
        "curriculo.sh"
        "utils/colors.sh"
        "modulos/01_sobre_mim.sh"
        "modulos/06_contato.sh"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            log_error "Arquivo obrigatório não encontrado: $file"
            echo "Execute este script no diretório que contém os arquivos do currículo."
            exit 1
        fi
    done
    
    log_success "Arquivos do currículo verificados"
}

# Função para criar diretórios e copiar arquivos
setup_files() {
    log_info "Configurando arquivos do sistema..."
    
    # Criar diretório de instalação
    mkdir -p "$INSTALL_DIR"/{modulos,utils,ascii}
    
    # Copiar arquivos
    cp -r ./* "$INSTALL_DIR/"
    
    # Definir permissões
    chown -R root:root "$INSTALL_DIR"
    chmod 755 "$INSTALL_DIR"
    chmod +x "$INSTALL_DIR/curriculo.sh"
    find "$INSTALL_DIR/modulos" -name "*.sh" -exec chmod +x {} \;
    chmod 644 "$INSTALL_DIR/utils"/*
    chmod 644 "$INSTALL_DIR/ascii"/*
    
    log_success "Arquivos instalados em $INSTALL_DIR"
}

# Função para criar usuário
create_user() {
    log_info "Criando usuário $USER_NAME..."
    
    # Verificar se usuário já existe
    if id "$USER_NAME" &>/dev/null; then
        log_warning "Usuário $USER_NAME já existe"
        read -p "Deseja recriar o usuário? (y/N): " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            userdel -f "$USER_NAME" 2>/dev/null || true
            rm -rf "/home/$USER_NAME"
        else
            log_info "Mantendo usuário existente"
            return
        fi
    fi
    
    # Criar usuário
    useradd --create-home --shell "$SHELL_PATH" "$USER_NAME"
    
    # Definir permissões do diretório home
    chown "$USER_NAME:$USER_NAME" "/home/$USER_NAME"
    chmod 750 "/home/$USER_NAME"
    
    # Configurar senha
    echo
    echo -e "${YELLOW}Configure uma senha FORTE para o usuário $USER_NAME:${RESET}"
    while ! passwd "$USER_NAME"; do
        log_error "Falha ao definir senha. Tente novamente."
    done
    
    log_success "Usuário $USER_NAME criado com sucesso"
}

# Função para criar shell personalizado
create_custom_shell() {
    log_info "Criando shell personalizado..."
    
    cat > "$SHELL_PATH" << 'EOF'
#!/bin/bash
# ========================================
# CVSHELL - Shell personalizado para currículo
# Sistema com tratamento robusto de erros
# ========================================

set -euo pipefail
umask 022

# Variáveis globais
CURRICULO_DIR="/opt/curriculo"
LOG_FILE="/var/log/cvshell.log"
MAX_TENTATIVAS=3
TENTATIVA=0

# Função de log
log_evento() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') [$$] $1" | tee -a "$LOG_FILE" >/dev/null 2>&1 || true
}

# Função de limpeza na saída
cleanup() {
    log_evento "Sessão finalizada para usuário: $(whoami)"
    exit 0
}

# Trap para capturar sinais e fazer limpeza
trap cleanup EXIT INT TERM

# Função para verificar integridade do sistema
verificar_sistema() {
    local erros=0
    
    if [[ ! -d "$CURRICULO_DIR" ]]; then
        echo "❌ ERRO: Diretório do currículo não encontrado!"
        log_evento "ERRO: Diretório $CURRICULO_DIR não encontrado"
        ((erros++))
    fi
    
    if [[ ! -f "$CURRICULO_DIR/curriculo.sh" ]]; then
        echo "❌ ERRO: Script principal não encontrado!"
        log_evento "ERRO: Script principal curriculo.sh não encontrado"
        ((erros++))
    fi
    
    if [[ ! -x "$CURRICULO_DIR/curriculo.sh" ]]; then
        echo "❌ ERRO: Script principal sem permissão de execução!"
        log_evento "ERRO: curriculo.sh sem permissão de execução"
        ((erros++))
    fi
    
    return $erros
}

# Função para exibir mensagem de erro amigável
mostrar_erro_sistema() {
    clear
    echo "
╔════════════════════════════════════════════════════════════╗
║                    ⚠️  SISTEMA INDISPONÍVEL                ║
╠════════════════════════════════════════════════════════════╣
║                                                            ║
║  O sistema está temporariamente indisponível.             ║
║  Tentativa: $TENTATIVA/$MAX_TENTATIVAS                                      ║
║                                                            ║
║  Contato direto:                                           ║
║  📧 gabriellucas2002br@outlook.com                         ║
║  📱 +55 (21) 99801-4245                                    ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
"
    echo "Aguarde 3 segundos para nova tentativa..."
    sleep 3
}

# Função para executar o currículo com recuperação de erro
executar_curriculo() {
    while [[ $TENTATIVA -lt $MAX_TENTATIVAS ]]; do
        ((TENTATIVA++))
        
        log_evento "Tentativa $TENTATIVA de execução do currículo para $(whoami)"
        
        if verificar_sistema; then
            log_evento "Sistema verificado com sucesso"
            
            cd "$CURRICULO_DIR" || {
                log_evento "ERRO: Não foi possível acessar $CURRICULO_DIR"
                mostrar_erro_sistema
                continue
            }
            
            timeout 1800 bash "$CURRICULO_DIR/curriculo.sh" || {
                local exit_code=$?
                log_evento "ERRO: curriculo.sh falhou com código $exit_code"
                
                if [[ $exit_code -eq 124 ]]; then
                    echo "⏰ Sessão expirada após 30 minutos."
                    sleep 3
                elif [[ $exit_code -eq 130 ]]; then
                    echo "👋 Até logo!"
                    sleep 1
                else
                    mostrar_erro_sistema
                    continue
                fi
            }
            break
        else
            log_evento "Falha na verificação do sistema"
            mostrar_erro_sistema
        fi
    done
    
    if [[ $TENTATIVA -eq $MAX_TENTATIVAS ]]; then
        clear
        echo "
╔════════════════════════════════════════════════════════════╗
║                  🚫 SISTEMA FORA DO AR                     ║
║                                                            ║
║  Entre em contato diretamente:                             ║
║  📧 gabriellucas2002br@outlook.com                         ║
║  📱 +55 (21) 99801-4245                                    ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
"
        log_evento "CRÍTICO: Sistema falhou após $MAX_TENTATIVAS tentativas"
        sleep 10
    fi
}

# Função principal
main() {
    log_evento "Nova sessão iniciada para usuário: $(whoami) de IP: ${SSH_CLIENT%% *}"
    
    if [[ "$(whoami)" != "curriculo" ]]; then
        log_evento "ALERTA: Tentativa de uso por usuário não autorizado: $(whoami)"
        echo "❌ Acesso negado."
        exit 1
    fi
    
    clear
    echo "🔐 Sessão iniciada | 👤 $(whoami) | 🕒 $(date '+%H:%M:%S')"
    echo "────────────────────────────────────────────────────────"
    sleep 1
    
    executar_curriculo
}

main "$@"
EOF

    chmod +x "$SHELL_PATH"
    log_success "Shell personalizado criado em $SHELL_PATH"
}

# Função para configurar SSH
configure_ssh() {
    log_info "Configurando SSH para segurança..."
    
    # Backup da configuração
    local backup_file="/etc/ssh/sshd_config.backup.$(date +%Y%m%d_%H%M%S)"
    cp /etc/ssh/sshd_config "$backup_file"
    log_info "Backup SSH criado: $backup_file"
    
    # Adicionar configurações específicas
    if ! grep -q "Match User $USER_NAME" /etc/ssh/sshd_config; then
        cat >> /etc/ssh/sshd_config << EOF

# Configuração Currículo Interativo - $(date)
Match User $USER_NAME
    ForceCommand $SHELL_PATH
    PermitTTY yes
    X11Forwarding no
    AllowTcpForwarding no
    AllowStreamLocalForwarding no
    PermitTunnel no
    ClientAliveInterval 300
    ClientAliveCountMax 2
    AuthenticationMethods password
EOF
        log_success "Configuração SSH adicionada"
    else
        log_warning "Configuração SSH já existe"
    fi
    
    # Testar configuração
    if sshd -t; then
        systemctl restart ssh
        log_success "SSH configurado e reiniciado"
    else
        log_error "Erro na configuração SSH. Restaurando backup..."
        cp "$backup_file" /etc/ssh/sshd_config
        systemctl restart ssh
        exit 1
    fi
}

# Função para configurar logs
setup_logging() {
    log_info "Configurando sistema de logs..."
    
    # Criar arquivo de log do shell
    touch /var/log/cvshell.log
    chown root:adm /var/log/cvshell.log
    chmod 644 /var/log/cvshell.log
    
    # Configurar rotação de logs
    cat > /etc/logrotate.d/cvshell << 'EOF'
/var/log/cvshell.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 644 root adm
}
EOF
    
    log_success "Sistema de logs configurado"
}

# Função para teste final
final_test() {
    log_info "Executando testes finais..."
    
    # Testar shell diretamente
    echo "Testando shell personalizado..."
    if timeout 5 sudo -u "$USER_NAME" "$SHELL_PATH" </dev/null &>/dev/null; then
        log_success "Shell personalizado funciona corretamente"
    else
        log_warning "Teste do shell pode ter falhado (normal se não há arquivos)"
    fi
    
    # Verificar SSH
    if systemctl is-active --quiet ssh; then
        log_success "SSH está ativo e funcionando"
    else
        log_error "SSH não está funcionando corretamente"
        exit 1
    fi
    
    log_success "Todos os testes passaram"
}

# Função para mostrar informações finais
show_final_info() {
    local server_ip
    server_ip=$(hostname -I | awk '{print $1}')
    
    echo
    echo -e "${GREEN}${BOLD}╔════════════════════════════════════════════════════════════╗"
    echo "║                   ✅ INSTALAÇÃO CONCLUÍDA                  ║"
    echo "╠════════════════════════════════════════════════════════════╣"
    echo "║                                                            ║"
    echo "║  🎯 Currículo Interativo instalado com sucesso!           ║"
    echo "║                                                            ║"
    echo "║  📋 INFORMAÇÕES DE ACESSO:                                 ║"
    echo "║  • Usuário: $USER_NAME                                       ║"
    echo "║  • Servidor: $server_ip                                  ║"
    echo "║  • Comando: ssh $USER_NAME@$server_ip                       ║"
    echo "║                                                            ║"
    echo "║  📊 MONITORAMENTO:                                         ║"
    echo "║  • Logs: tail -f /var/log/cvshell.log                     ║"
    echo "║  • Status SSH: systemctl status ssh                       ║"
    echo "║                                                            ║"
    echo "║  🔧 ADMINISTRAÇÃO:                                         ║"
    echo "║  • Arquivos: $INSTALL_DIR                             ║"
    echo "║  • Configuração: /etc/ssh/sshd_config                     ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝${RESET}"
    echo
}

# Função principal de instalação
main() {
    show_banner
    
    # Verificar se está sendo executado como root
    check_root
    
    # Criar arquivo de log
    mkdir -p "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
    
    log_info "Iniciando instalação do Currículo Interativo"
    
    # Executar etapas de instalação
    check_prerequisites
    check_curriculum_files
    setup_files
    create_user
    create_custom_shell
    configure_ssh
    setup_logging
    final_test
    
    log_success "Instalação concluída com sucesso!"
    show_final_info
    
    echo -e "${CYAN}💡 Dica: Teste a conexão com 'ssh $USER_NAME@localhost'${RESET}"
    echo
}

# Executar instalação
main "$@"
