#!/bin/bash
# ==============================================================================
# ✔ INSTALADOR AUTOMATICO DO CURRICULO INTERATIVO
# Script para configuração completa do servidor
# ==============================================================================

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
    echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[OK]${RESET} $1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') [OK] $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERRO]${RESET} $1" >&2
    echo "$(date +'%Y-%m-%d %H:%M:%S') [ERRO] $1" >> "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[AVISO]${RESET} $1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') [AVISO] $1" >> "$LOG_FILE"
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
    echo " 🚀 INSTALADOR CURRÍCULO INTERATIVO"
    echo " ──────────────────────────────────────────────────────────"
    echo " Configuração automática de servidor para demonstração"
    echo " de currículo em Bash com máxima segurança"
    echo " ──────────────────────────────────────────────────────────"
    echo -e "${RESET}"
}

# Função para verificar pré-requisitos
check_dependencies() {
    log_info "Verificando dependências do sistema..."
    local missing_deps=()
    local deps=("git" "openssh-server" "sudo")

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Dependências faltando: ${missing_deps[*]}. Instale-as e tente novamente."
        exit 1
    fi
    log_success "Todas as dependências foram atendidas."
}

# Função para criar usuário restrito
create_user() {
    log_info "Criando usuário restrito '$USER_NAME'..."
    if id "$USER_NAME" &>/dev/null; then
        log_warning "Usuário '$USER_NAME' já existe. Pulando criação."
    else
        sudo useradd -m -s "$SHELL_PATH" "$USER_NAME"
        if [ $? -ne 0 ]; then
            log_error "Falha ao criar usuário '$USER_NAME'."
            exit 1
        fi
        log_success "Usuário '$USER_NAME' criado com sucesso."
    fi

    log_info "Definindo senha para o usuário '$USER_NAME'..."
    echo "$USER_NAME:curriculo" | sudo chpasswd
    log_success "Senha definida com sucesso. Use 'curriculo' para acessar."
}

# Função para configurar o shell customizado
setup_shell() {
    log_info "Configurando shell customizado em '$SHELL_PATH'..."
    
    # Conteúdo do cvshell
    local shell_script="#!/bin/bash
# CVSHELL - Currículo Interativo Shell

function run_curriculo() {
    /opt/curriculo/curriculo.sh
}

# Trap para garantir que o menu principal seja chamado em caso de erro
trap 'run_curriculo' ERR

# Loop de recuperação
MAX_RETRIES=3
RETRY_COUNT=0

while [ \$RETRY_COUNT -lt \$MAX_RETRIES ]; do
    run_curriculo
    if [ \$? -eq 0 ]; then
        # Saída normal, finaliza o loop
        break
    else
        echo -e '\\n[SISTEMA] Ocorreu um erro. Tentando reiniciar em 3 segundos...'
        sleep 3
        RETRY_COUNT=\$((RETRY_COUNT + 1))
    fi
done

if [ \$RETRY_COUNT -ge \$MAX_RETRIES ]; then
    echo -e '\\n[SISTEMA] Não foi possível recuperar a sessão. Desconectando.'
fi

exit 0
"

    echo "$shell_script" | sudo tee "$SHELL_PATH" > /dev/null
    sudo chmod +x "$SHELL_PATH"

    if ! grep -q "$SHELL_PATH" /etc/shells; then
        log_info "Adicionando '$SHELL_PATH' a /etc/shells..."
        echo "$SHELL_PATH" | sudo tee -a /etc/shells > /dev/null
    fi

    log_success "Shell customizado configurado."
}

# Função para clonar ou atualizar o repositório
setup_repo() {
    log_info "Configurando repositório do currículo em '$INSTALL_DIR'..."
    if [ -d "$INSTALL_DIR" ]; then
        log_warning "Diretório '$INSTALL_DIR' já existe. Sincronizando com o repositório..."
        sudo git -C "$INSTALL_DIR" pull
    else
        sudo git clone https://github.com/GabrielDSant/Curriculo.git "$INSTALL_DIR"
    fi
    
    sudo chown -R root:root "$INSTALL_DIR"
    sudo chmod -R 755 "$INSTALL_DIR"
    sudo chmod +x "$INSTALL_DIR"/*.sh
    sudo chmod +x "$INSTALL_DIR"/modulos/*.sh

    log_success "Repositório configurado e permissões ajustadas."
}

# Função para configurar a segurança do SSH
setup_ssh() {
    log_info "Configurando segurança do SSH..."
    local sshd_config="/etc/ssh/sshd_config"

    # Backup do arquivo de configuração original
    sudo cp "$sshd_config" "${sshd_config}.bak_$(date +%F)"

    # Configurações de segurança
    sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' "$sshd_config"
    sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$sshd_config"
    sudo sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "$sshd_config"
    sudo sed -i 's/^#\?UsePAM.*/UsePAM yes/' "$sshd_config"
    sudo sed -i 's/^#\?X11Forwarding.*/X11Forwarding no/' "$sshd_config"
    sudo sed -i 's/^#\?PrintMotd.*/PrintMotd no/' "$sshd_config"
    sudo sed -i 's/^#\?AllowTcpForwarding.*/AllowTcpForwarding no/' "$sshd_config"

    # Restringir usuário ao seu shell
    if ! grep -q "Match User $USER_NAME" "$sshd_config"; then
        echo -e "\nMatch User $USER_NAME\n    ForceCommand $SHELL_PATH\n    PasswordAuthentication yes\n    AllowTcpForwarding no\n    X11Forwarding no" | sudo tee -a "$sshd_config" > /dev/null
    fi

    log_info "Reiniciando serviço SSH para aplicar as configurações..."
    sudo systemctl restart sshd
    log_success "SSH configurado com segurança."
}

# Função para configurar firewall (UFW)
setup_firewall() {
    log_info "Configurando firewall (UFW)..."
    if ! command -v ufw &> /dev/null; then
        log_warning "UFW não encontrado. Pulando configuração de firewall."
        return
    fi

    sudo ufw allow ssh
    sudo ufw --force enable
    
    # Proteção contra DDoS simples
    sudo ufw limit ssh/tcp

    log_success "Firewall configurado para permitir e limitar conexões SSH."
}

# Função para configurar sistema de logs
setup_logging() {
    log_info "Configurando sistema de logs..."
    sudo touch /var/log/cvshell.log
    sudo chown $USER_NAME:$USER_NAME /var/log/cvshell.log
    
    local logrotate_conf="/etc/logrotate.d/cvshell"
    local logrotate_script="/var/log/cvshell.log {\n    daily\n    rotate 7\n    compress\n    delaycompress\n    missingok\n    notifempty\n    create 644 $USER_NAME $USER_NAME\n}"

    echo -e "$logrotate_script" | sudo tee "$logrotate_conf" > /dev/null
    log_success "Sistema de logs e rotação configurados."
}

# Função para executar testes de validação
run_tests() {
    log_info "Executando testes de validação..."
    if [ -f "$INSTALL_DIR/teste_sistema.sh" ]; then
        sudo chmod +x "$INSTALL_DIR/teste_sistema.sh"
        if sudo "$INSTALL_DIR/teste_sistema.sh"; then
            log_success "Testes de validação concluídos com sucesso."
        else
            log_error "Falha nos testes de validação. Verifique os logs."
        fi
    else
        log_warning "Script de teste não encontrado. Pulando."
    fi
}

# Função para exibir informações de acesso
show_access_info() {
    local ip_address=$(hostname -I | awk '{print $1}')
    echo -e "${GREEN}${BOLD}"
    echo "=================================================="
    echo " ✅ INSTALAÇÃO CONCLUÍDA COM SUCESSO"
    echo "=================================================="
    echo -e "${RESET}"
    echo "Acesse o currículo interativo com o seguinte comando:"
    echo -e "${YELLOW}ssh ${USER_NAME}@${ip_address}${RESET}"
    echo "A senha é: ${YELLOW}curriculo${RESET}"
    echo ""
    echo "Para gerenciar o sistema, use: ${CYAN}sudo /opt/curriculo/manage.sh${RESET}"
    echo "Log de instalação: ${BLUE}${LOG_FILE}${RESET}"
    echo "Log de acesso: ${BLUE}/var/log/cvshell.log${RESET}"
}

# Função principal
main() {
    # Inicialização
    check_root
    sudo touch "$LOG_FILE"
    
    show_banner
    log_info "Iniciando instalação do Currículo Interativo..."

    # Passos da instalação
    check_dependencies
    setup_repo
    setup_shell
    create_user
    setup_ssh
    setup_firewall
    setup_logging
    run_tests

    # Finalização
    show_access_info
    log_info "Instalação finalizada."
}

# Executar a função principal
main


