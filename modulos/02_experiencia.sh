#!/bin/bash
source utils/colors.sh

clear
box "💼 EXPERIÊNCIA PROFISSIONAL" "$BOLD$CYAN"
echo

# Função para mostrar experiência
mostrar_experiencia() {
    local cargo="$1"
    local empresa="$2"
    local periodo="$3"
    local cor_cargo="$4"
    shift 4
    local atividades=("$@")
    
    echo -e "${BOLD}${cor_cargo}🏢 $cargo${RESET}"
    echo -e "${WHITE}📍 $empresa | ⏰ $periodo${RESET}"
    separator "─" 50 "$DIM"
    
    for atividade in "${atividades[@]}"; do
        echo -e "   ${GREEN}▶${RESET} $atividade"
    done
    echo
}

loading 1 "Carregando histórico profissional" "$CYAN"

mostrar_experiencia \
    "Analista de Sistemas Jr" \
    "FioSaúde" \
    "agosto/2023 - Atual" \
    "$BOLD$BLUE" \
    "Implementação de soluções de ${BOLD}IA${RESET} para automação da análise de glosas" \
    "Integração de ${BOLD}WebViews${RESET} em aplicações mobile" \
    "Desenvolvimento e integração de ${BOLD}APIs RESTful${RESET}" \
    "Automação de rotinas críticas (${BOLD}Python, PHP, Shell Script${RESET})" \
    "Otimização de queries e procedures ${BOLD}PL/SQL${RESET} (até ${BOLD}95% de melhoria${RESET})" \
    "Gestão de infraestrutura ${BOLD}containerizada (Docker)${RESET}" \
    "Administração de servidores ${BOLD}Linux${RESET}"

separator "═" 60 "$CYAN"

mostrar_experiencia \
    "Jovem Aprendiz - Desenvolvedor Fullstack PHP" \
    "FioSaúde" \
    "agosto/2022 - agosto/2023" \
    "$BOLD$YELLOW" \
    "Desenvolvimento backend ${BOLD}seguro e escalável${RESET}" \
    "Implementação de rotinas de ${BOLD}testes automatizados${RESET}" \
    "Criação de ${BOLD}documentação técnica${RESET}" \
    "Colaboração em projetos ${BOLD}full-stack${RESET}"

echo
box "🎯 IMPACTO: +1 ano na FioSaúde com crescimento de Aprendiz para Analista Jr!" "$BOLD$GREEN"
