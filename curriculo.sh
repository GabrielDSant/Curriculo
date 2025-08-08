#!/bin/bash
source utils/colors.sh

MODULOS_DIR="./modulos"

# Tela de boas-vindas
mostrar_boas_vindas() {
    clear
    echo -e "${BOLD}${GREEN}"
    cat ascii/welcome.txt
    echo -e "${RESET}"
    echo
    separator "═" 80 "$CYAN"
    typewriter "Bem-vindo ao meu Currículo Interativo!" 0.03 "$BOLD$WHITE"
    echo
    typewriter "Sistema desenvolvido para demonstrar habilidades técnicas" 0.02 "$DIM$CYAN"
    typewriter "enquanto apresento minha experiência profissional." 0.02 "$DIM$CYAN"
    echo
    separator "═" 80 "$CYAN"
    echo
    loading 2 "Inicializando sistema" "$YELLOW"
    sleep 1
}

mostrar_todos() {
    clear
    box "VISUALIZAÇÃO COMPLETA - TODOS OS MÓDULOS" "$BOLD$GREEN"
    echo
    
    local contador=1
    for modulo in $(ls "$MODULOS_DIR" | sort); do
        echo -e "${BOLD}${BLUE}[${contador}/6] Carregando: ${modulo}${RESET}"
        loading 1 "Preparando módulo" "$CYAN"
        bash "$MODULOS_DIR/$modulo"
        echo -e "\n${CYAN}$(separator "─" 60)${RESET}\n"
        echo -e "${DIM}Pressione Enter para continuar para o próximo módulo...${RESET}"
        read
        ((contador++))
    done
    
    echo
    box "VISUALIZAÇÃO COMPLETA FINALIZADA!" "$BOLD$GREEN"
    echo -e "${BOLD}${WHITE}Obrigado por conhecer meu perfil profissional!${RESET}"
    echo
}

mostrar_um() {
    clear
    box "NAVEGAÇÃO INDIVIDUAL - ESCOLHA UM MÓDULO" "$BOLD$BLUE"
    echo
    
    PS3="$(echo -e "${BOLD}${YELLOW}Digite o número da sua escolha: ${RESET}")"
    select modulo in $(ls "$MODULOS_DIR" | sort | sed 's/^[0-9]*_//;s/\.sh$//;s/_/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1') "🔙 Voltar ao Menu Principal"; do
        if [[ "$modulo" == "🔙 Voltar ao Menu Principal" ]]; then
            break
        elif [[ -n "$modulo" ]]; then
            # Converter de volta para nome do arquivo
            local arquivo_modulo=$(ls "$MODULOS_DIR" | sort | sed -n "${REPLY}p")
            if [[ -n "$arquivo_modulo" ]]; then
                clear
                loading 1 "Carregando módulo selecionado" "$CYAN"
                bash "$MODULOS_DIR/$arquivo_modulo"
                echo
                separator "─" 50 "$CYAN"
                echo -e "${DIM}Pressione Enter para voltar ao menu...${RESET}"
                read
                clear
                box "NAVEGAÇÃO INDIVIDUAL - ESCOLHA UM MÓDULO" "$BOLD$BLUE"
                echo
            fi
        else
            echo -e "${RED}❌ Opção inválida. Tente novamente.${RESET}"
        fi
    done
}

# Função para mostrar estatísticas do sistema
mostrar_stats() {
    clear
    box "INFORMAÇÕES DO SISTEMA" "$BOLD$MAGENTA"
    echo
    echo -e "${CYAN}📊 Estatísticas do Currículo:${RESET}"
    echo -e "   • Módulos disponíveis: ${BOLD}$(ls "$MODULOS_DIR" | wc -l)${RESET}"
    echo -e "   • Tecnologias apresentadas: ${BOLD}$(ls ascii/ | grep -v welcome.txt | wc -l)${RESET}"
    echo -e "   • Desenvolvido em: ${BOLD}Bash Script${RESET}"
    echo -e "   • Servidor: ${BOLD}$(whoami)@$(hostname)${RESET}"
    echo -e "   • Sistema: ${BOLD}$(uname -s) $(uname -r)${RESET}"
    echo
    separator "─" 50 "$CYAN"
    echo -e "${DIM}Pressione Enter para voltar...${RESET}"
    read
}

# Mostrar boas-vindas apenas na primeira execução
mostrar_boas_vindas

# Menu principal
while true; do
    clear
    echo -e "${BOLD}${GREEN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║                  📋 CURRÍCULO INTERATIVO                   ║"
    echo "║                   Gabriel Lucas Sant'Anna                  ║"
    echo "╠════════════════════════════════════════════════════════════╣"
    echo "║                                                            ║"
    echo "║  1️⃣  Ver todos os módulos em sequência                     ║"
    echo "║  2️⃣  Navegar módulo por módulo                             ║"
    echo "║  3️⃣  Informações do sistema                                ║"
    echo "║  4️⃣  Sair                                                  ║"
    echo "║                                                            ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    
    echo -ne "${BOLD}${YELLOW}🎯 Escolha uma opção [1-4]: ${RESET}"
    read opt

    case "$opt" in
        1) mostrar_todos ;;
        2) mostrar_um ;;
        3) mostrar_stats ;;
        4) 
            clear
            echo -e "${BOLD}${GREEN}"
            echo "╔════════════════════════════════════════════════════════════╗"
            echo "║                      👋 OBRIGADO!                          ║"
            echo "║                                                            ║"
            echo "║         Espero que tenha gostado da apresentação!          ║"
            echo "║                                                            ║"
            echo "║    📧 gabriel.santanna@email.com                          ║"
            echo "║    💼 LinkedIn: /in/gabriel-santanna                       ║"
            echo "║    🐙 GitHub: /gabriel-santanna                           ║"
            echo "║                                                            ║"
            echo "╚════════════════════════════════════════════════════════════╝"
            echo -e "${RESET}"
            exit 0 
            ;;
        *) 
            echo -e "${RED}❌ Opção inválida. Por favor, escolha entre 1 e 4.${RESET}"
            sleep 2
            ;;
    esac
done
