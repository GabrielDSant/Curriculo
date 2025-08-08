#!/bin/bash
# ========================================
# 🛠️  GERENCIADOR DO CURRÍCULO INTERATIVO
# Script para administração e monitoramento
# ========================================

set -euo pipefail

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Variáveis
USER_NAME="curriculo"
INSTALL_DIR="/opt/curriculo"
LOG_FILE="/var/log/cvshell.log"
SHELL_PATH="/usr/bin/cvshell"

# Função para exibir menu
show_menu() {
    clear
    echo -e "${CYAN}${BOLD}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║            🛠️  GERENCIADOR CURRÍCULO INTERATIVO            ║"
    echo "╠════════════════════════════════════════════════════════════╣"
    echo "║                                                            ║"
    echo "║  1️⃣  📊 Status do Sistema                                   ║"
    echo "║  2️⃣  📋 Logs em Tempo Real                                  ║"
    echo "║  3️⃣  👥 Usuários Conectados                                 ║"
    echo "║  4️⃣  🔄 Reiniciar Serviços                                  ║"
    echo "║  5️⃣  🧪 Testar Sistema                                      ║"
    echo "║  6️⃣  📁 Backup dos Arquivos                                 ║"
    echo "║  7️⃣  🔧 Atualizar Arquivos                                  ║"
    echo "║  8️⃣  📈 Estatísticas de Uso                                 ║"
    echo "║  9️⃣  🗑️  Remover Sistema                                    ║"
    echo "║  0️⃣  🚪 Sair                                                ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# Função para verificar se é root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}❌ Este script deve ser executado como root (sudo)${RESET}"
        exit 1
    fi
}

# 1. Status do Sistema
show_status() {
    echo -e "${BLUE}${BOLD}📊 STATUS DO SISTEMA${RESET}"
    echo "══════════════════════════════════════════════"
    
    # Verificar usuário
    if id "$USER_NAME" &>/dev/null; then
        echo -e "👤 Usuário '$USER_NAME': ${GREEN}✅ Existe${RESET}"
        echo "   Shell: $(getent passwd "$USER_NAME" | cut -d: -f7)"
        echo "   Home: $(getent passwd "$USER_NAME" | cut -d: -f6)"
    else
        echo -e "👤 Usuário '$USER_NAME': ${RED}❌ Não encontrado${RESET}"
    fi
    
    # Verificar arquivos
    if [[ -d "$INSTALL_DIR" ]]; then
        echo -e "📁 Diretório de instalação: ${GREEN}✅ Existe${RESET}"
        echo "   Localização: $INSTALL_DIR"
        echo "   Arquivos: $(find "$INSTALL_DIR" -type f | wc -l)"
    else
        echo -e "📁 Diretório de instalação: ${RED}❌ Não encontrado${RESET}"
    fi
    
    # Verificar shell personalizado
    if [[ -x "$SHELL_PATH" ]]; then
        echo -e "🐚 Shell personalizado: ${GREEN}✅ Funcionando${RESET}"
    else
        echo -e "🐚 Shell personalizado: ${RED}❌ Problema${RESET}"
    fi
    
    # Verificar SSH
    if systemctl is-active --quiet ssh; then
        echo -e "🔐 Serviço SSH: ${GREEN}✅ Ativo${RESET}"
    else
        echo -e "🔐 Serviço SSH: ${RED}❌ Inativo${RESET}"
    fi
    
    # Verificar logs
    if [[ -f "$LOG_FILE" ]]; then
        local log_size=$(du -h "$LOG_FILE" | cut -f1)
        local log_lines=$(wc -l < "$LOG_FILE")
        echo -e "📝 Arquivo de log: ${GREEN}✅ Existe${RESET}"
        echo "   Tamanho: $log_size | Linhas: $log_lines"
    else
        echo -e "📝 Arquivo de log: ${RED}❌ Não encontrado${RESET}"
    fi
    
    echo
    read -p "Pressione Enter para continuar..."
}

# 2. Logs em Tempo Real
show_logs() {
    echo -e "${BLUE}${BOLD}📋 LOGS EM TEMPO REAL${RESET}"
    echo "Pressione Ctrl+C para sair"
    echo "══════════════════════════════════════════════"
    
    if [[ -f "$LOG_FILE" ]]; then
        tail -f "$LOG_FILE"
    else
        echo -e "${RED}❌ Arquivo de log não encontrado: $LOG_FILE${RESET}"
        read -p "Pressione Enter para continuar..."
    fi
}

# 3. Usuários Conectados
show_connections() {
    echo -e "${BLUE}${BOLD}👥 USUÁRIOS CONECTADOS${RESET}"
    echo "══════════════════════════════════════════════"
    
    echo "Conexões SSH ativas:"
    if command -v ss &>/dev/null; then
        ss -tuln | grep :22 || echo "Nenhuma conexão SSH encontrada"
    else
        netstat -tuln | grep :22 || echo "Nenhuma conexão SSH encontrada"
    fi
    
    echo
    echo "Usuários logados:"
    who || echo "Nenhum usuário logado"
    
    echo
    echo "Últimos logins do usuário $USER_NAME:"
    lastlog -u "$USER_NAME" 2>/dev/null || echo "Sem informações de login"
    
    echo
    read -p "Pressione Enter para continuar..."
}

# 4. Reiniciar Serviços
restart_services() {
    echo -e "${BLUE}${BOLD}🔄 REINICIAR SERVIÇOS${RESET}"
    echo "══════════════════════════════════════════════"
    
    echo "Reiniciando SSH..."
    if systemctl restart ssh; then
        echo -e "${GREEN}✅ SSH reiniciado com sucesso${RESET}"
    else
        echo -e "${RED}❌ Erro ao reiniciar SSH${RESET}"
    fi
    
    echo
    echo "Verificando configuração SSH..."
    if sshd -t; then
        echo -e "${GREEN}✅ Configuração SSH válida${RESET}"
    else
        echo -e "${RED}❌ Erro na configuração SSH${RESET}"
    fi
    
    echo
    read -p "Pressione Enter para continuar..."
}

# 5. Testar Sistema
test_system() {
    echo -e "${BLUE}${BOLD}🧪 TESTE DO SISTEMA${RESET}"
    echo "══════════════════════════════════════════════"
    
    echo "Testando shell personalizado..."
    if timeout 5 sudo -u "$USER_NAME" "$SHELL_PATH" </dev/null &>/dev/null; then
        echo -e "${GREEN}✅ Shell personalizado funcionando${RESET}"
    else
        echo -e "${YELLOW}⚠️  Shell pode ter problemas (timeout ou erro)${RESET}"
    fi
    
    echo
    echo "Testando conexão SSH local..."
    if timeout 10 ssh -o ConnectTimeout=5 -o BatchMode=yes "$USER_NAME@localhost" echo "Teste OK" 2>/dev/null; then
        echo -e "${GREEN}✅ Conexão SSH funcionando${RESET}"
    else
        echo -e "${YELLOW}⚠️  Conexão SSH pode ter problemas${RESET}"
    fi
    
    echo
    echo "Verificando arquivos obrigatórios..."
    local required_files=("$INSTALL_DIR/curriculo.sh" "$INSTALL_DIR/utils/colors.sh")
    for file in "${required_files[@]}"; do
        if [[ -f "$file" ]]; then
            echo -e "   ${GREEN}✅${RESET} $file"
        else
            echo -e "   ${RED}❌${RESET} $file"
        fi
    done
    
    echo
    read -p "Pressione Enter para continuar..."
}

# 6. Backup dos Arquivos
create_backup() {
    echo -e "${BLUE}${BOLD}📁 BACKUP DOS ARQUIVOS${RESET}"
    echo "══════════════════════════════════════════════"
    
    local backup_dir="/root/curriculo_backup_$(date +%Y%m%d_%H%M%S)"
    
    echo "Criando backup em: $backup_dir"
    
    mkdir -p "$backup_dir"
    
    # Backup dos arquivos
    if [[ -d "$INSTALL_DIR" ]]; then
        cp -r "$INSTALL_DIR" "$backup_dir/curriculo_files"
        echo -e "${GREEN}✅ Arquivos do currículo copiados${RESET}"
    fi
    
    # Backup da configuração SSH
    if [[ -f "/etc/ssh/sshd_config" ]]; then
        cp "/etc/ssh/sshd_config" "$backup_dir/sshd_config"
        echo -e "${GREEN}✅ Configuração SSH copiada${RESET}"
    fi
    
    # Backup do shell personalizado
    if [[ -f "$SHELL_PATH" ]]; then
        cp "$SHELL_PATH" "$backup_dir/cvshell"
        echo -e "${GREEN}✅ Shell personalizado copiado${RESET}"
    fi
    
    # Backup dos logs
    if [[ -f "$LOG_FILE" ]]; then
        cp "$LOG_FILE" "$backup_dir/cvshell.log"
        echo -e "${GREEN}✅ Logs copiados${RESET}"
    fi
    
    # Criar arquivo com informações do sistema
    cat > "$backup_dir/system_info.txt" << EOF
Backup criado em: $(date)
Usuário: $USER_NAME
Diretório de instalação: $INSTALL_DIR
Shell personalizado: $SHELL_PATH
Log file: $LOG_FILE

Sistema:
$(uname -a)

Versão SSH:
$(ssh -V 2>&1)
EOF
    
    echo
    echo -e "${GREEN}✅ Backup criado com sucesso!${RESET}"
    echo "Localização: $backup_dir"
    
    echo
    read -p "Pressione Enter para continuar..."
}

# 7. Atualizar Arquivos
update_files() {
    echo -e "${BLUE}${BOLD}🔧 ATUALIZAR ARQUIVOS${RESET}"
    echo "══════════════════════════════════════════════"
    
    echo "Esta função permite atualizar os arquivos do currículo."
    echo "Certifique-se de que os novos arquivos estão no diretório atual."
    echo
    
    read -p "Continuar com a atualização? (y/N): " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        return
    fi
    
    # Verificar se existem arquivos para atualizar
    if [[ ! -f "curriculo.sh" ]]; then
        echo -e "${RED}❌ Arquivo curriculo.sh não encontrado no diretório atual${RESET}"
        read -p "Pressione Enter para continuar..."
        return
    fi
    
    # Criar backup antes da atualização
    local backup_dir="/tmp/curriculo_backup_pre_update_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    cp -r "$INSTALL_DIR"/* "$backup_dir/"
    echo -e "${GREEN}✅ Backup pré-atualização criado em: $backup_dir${RESET}"
    
    # Copiar novos arquivos
    echo "Copiando arquivos atualizados..."
    cp -r ./* "$INSTALL_DIR/"
    
    # Restaurar permissões
    chown -R root:root "$INSTALL_DIR"
    chmod 755 "$INSTALL_DIR"
    chmod +x "$INSTALL_DIR/curriculo.sh"
    find "$INSTALL_DIR/modulos" -name "*.sh" -exec chmod +x {} \;
    
    echo -e "${GREEN}✅ Arquivos atualizados com sucesso!${RESET}"
    
    echo
    read -p "Pressione Enter para continuar..."
}

# 8. Estatísticas de Uso
show_stats() {
    echo -e "${BLUE}${BOLD}📈 ESTATÍSTICAS DE USO${RESET}"
    echo "══════════════════════════════════════════════"
    
    if [[ ! -f "$LOG_FILE" ]]; then
        echo -e "${RED}❌ Arquivo de log não encontrado${RESET}"
        read -p "Pressione Enter para continuar..."
        return
    fi
    
    echo "📊 Estatísticas gerais:"
    echo "   Total de linhas no log: $(wc -l < "$LOG_FILE")"
    echo "   Tamanho do arquivo: $(du -h "$LOG_FILE" | cut -f1)"
    echo
    
    echo "🔗 Sessões iniciadas (últimos 30 dias):"
    local sessions=$(grep "Nova sessão iniciada" "$LOG_FILE" | tail -100 | wc -l)
    echo "   Total: $sessions sessões"
    echo
    
    echo "📅 Últimos acessos:"
    grep "Nova sessão iniciada" "$LOG_FILE" | tail -10 | while read -r line; do
        echo "   $line"
    done
    
    echo
    echo "🔍 IPs mais frequentes:"
    grep "Nova sessão iniciada" "$LOG_FILE" | \
    grep -o 'IP: [0-9.]*' | \
    cut -d' ' -f2 | \
    sort | uniq -c | sort -nr | head -5
    
    echo
    read -p "Pressione Enter para continuar..."
}

# 9. Remover Sistema
remove_system() {
    echo -e "${RED}${BOLD}🗑️  REMOVER SISTEMA${RESET}"
    echo "══════════════════════════════════════════════"
    
    echo -e "${RED}⚠️  ATENÇÃO: Esta ação irá remover completamente o sistema!${RESET}"
    echo
    echo "Será removido:"
    echo "• Usuário $USER_NAME"
    echo "• Diretório $INSTALL_DIR"
    echo "• Shell personalizado $SHELL_PATH"
    echo "• Configurações SSH específicas"
    echo "• Logs em $LOG_FILE"
    echo
    
    read -p "Digite 'REMOVER' para confirmar a remoção completa: " -r
    if [[ "$REPLY" != "REMOVER" ]]; then
        echo "Operação cancelada."
        read -p "Pressione Enter para continuar..."
        return
    fi
    
    echo
    echo "Removendo sistema..."
    
    # Remover usuário
    if id "$USER_NAME" &>/dev/null; then
        userdel -r "$USER_NAME" 2>/dev/null || true
        echo -e "${GREEN}✅ Usuário removido${RESET}"
    fi
    
    # Remover diretório
    if [[ -d "$INSTALL_DIR" ]]; then
        rm -rf "$INSTALL_DIR"
        echo -e "${GREEN}✅ Diretório removido${RESET}"
    fi
    
    # Remover shell personalizado
    if [[ -f "$SHELL_PATH" ]]; then
        rm -f "$SHELL_PATH"
        echo -e "${GREEN}✅ Shell personalizado removido${RESET}"
    fi
    
    # Remover logs
    if [[ -f "$LOG_FILE" ]]; then
        rm -f "$LOG_FILE"
        echo -e "${GREEN}✅ Logs removidos${RESET}"
    fi
    
    # Remover configuração SSH
    if grep -q "Match User $USER_NAME" /etc/ssh/sshd_config; then
        cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup.removal.$(date +%Y%m%d)
        sed -i "/^# Configuração Currículo Interativo/,/^$/d" /etc/ssh/sshd_config
        systemctl restart ssh
        echo -e "${GREEN}✅ Configuração SSH limpa${RESET}"
    fi
    
    echo
    echo -e "${GREEN}✅ Sistema removido completamente!${RESET}"
    
    read -p "Pressione Enter para sair..."
    exit 0
}

# Função principal
main() {
    check_root
    
    while true; do
        show_menu
        
        echo -ne "${YELLOW}Escolha uma opção [0-9]: ${RESET}"
        read -r choice
        
        case "$choice" in
            1) show_status ;;
            2) show_logs ;;
            3) show_connections ;;
            4) restart_services ;;
            5) test_system ;;
            6) create_backup ;;
            7) update_files ;;
            8) show_stats ;;
            9) remove_system ;;
            0) echo "Até logo!"; exit 0 ;;
            *) echo -e "${RED}❌ Opção inválida!${RESET}"; sleep 2 ;;
        esac
    done
}

# Executar
main "$@"
