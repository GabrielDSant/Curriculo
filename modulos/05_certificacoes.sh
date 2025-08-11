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
    
    typewriter_colored "${BOLD}${cor}🏅 $nome${RESET}" 0.03
    typewriter_colored "   📅 $data | 🎯 Status: $status" 0.02
    if [[ -n "$descricao" ]]; then
        typewriter_colored "   💡 $descricao" 0.02
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

typewriter_colored "${BOLD}${BLUE}📚 EM ANDAMENTO:${RESET}" 0.03
typewriter_colored "   ${GREEN}▶${RESET} CompTIA Security+ (previsão: 2025)" 0.02
typewriter_colored "   ${GREEN}▶${RESET} Oracle Database SQL Certified Associate" 0.02
typewriter_colored "   ${GREEN}▶${RESET} Docker Certified Associate" 0.02
echo

separator "─" 50 "$CYAN"

typewriter_colored "${BOLD}${MAGENTA}🎯 PROJETOS DESTACADOS:${RESET}" 0.03
typewriter_colored "   ${CYAN}💻${RESET} ${BOLD}Currículo Interativo em Bash${RESET} - Este próprio sistema!" 0.02
typewriter_colored "   ${CYAN}🤖${RESET} ${BOLD}Sistema de IA para Análise de Glosas${RESET} - FioSaúde" 0.02
typewriter_colored "   ${CYAN}📱${RESET} ${BOLD}Integração WebView Mobile${RESET} - Aplicação híbrida" 0.02
typewriter_colored "   ${CYAN}🔧${RESET} ${BOLD}Scripts de Automação${RESET} - Otimização de processos" 0.02
echo

box "🚀 Sempre aprendendo e evoluindo!" "$BOLD$GREEN"
