#!/bin/bash
source utils/colors.sh

clear
box "🏆 CERTIFICAÇÕES & CONQUISTAS" "$BOLD$YELLOW"
echo

loading 1 "Carregando certificações" "$CYAN"

# Função para mostrar certificação
mostrar_certificacao() {
    local nome="$1"
    local data="$2"
    local status="$3"
    local cor="$4"
    local descricao="$5"
    
    echo -e "${BOLD}${cor}🏅 $nome${RESET}"
    echo -e "   📅 $data | 🎯 Status: $status"
    if [[ -n "$descricao" ]]; then
        echo -e "   💡 $descricao"
    fi
    echo
}

mostrar_certificacao \
    "AWS Certified Cloud Practitioner" \
    "janeiro/2025 - janeiro/2028" \
    "Válido" \
    "$ORANGE" \
    "Fundamentos de computação em nuvem AWS"

mostrar_certificacao \
    "GitHub Foundations" \
    "março/2025 - atual" \
    "Válido" \
    "$PURPLE" \
    "Fundamentos de controle de versão e colaboração"

separator "─" 50 "$CYAN"

echo -e "${BOLD}${BLUE}📚 EM ANDAMENTO:${RESET}"
echo -e "   ${GREEN}▶${RESET} CompTIA Security+ (previsão: 2025)"
echo -e "   ${GREEN}▶${RESET} Oracle Database SQL Certified Associate"
echo -e "   ${GREEN}▶${RESET} Docker Certified Associate"
echo

separator "─" 50 "$CYAN"

echo -e "${BOLD}${MAGENTA}🎯 PROJETOS DESTACADOS:${RESET}"
echo -e "   ${CYAN}💻${RESET} ${BOLD}Currículo Interativo em Bash${RESET} - Este próprio sistema!"
echo -e "   ${CYAN}🤖${RESET} ${BOLD}Sistema de IA para Análise de Glosas${RESET} - FioSaúde"
echo -e "   ${CYAN}📱${RESET} ${BOLD}Integração WebView Mobile${RESET} - Aplicação híbrida"
echo -e "   ${CYAN}🔧${RESET} ${BOLD}Scripts de Automação${RESET} - Otimização de processos"
echo

box "🚀 Sempre aprendendo e evoluindo!" "$BOLD$GREEN"
