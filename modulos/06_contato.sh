#!/bin/bash
source utils/colors.sh

clear
box "📞 CONTATO & REDES SOCIAIS" "$BOLD$GREEN"
echo

# ASCII para contato
echo -e "${CYAN}"
echo "    ╔═══════════════════════════════════════════╗"
echo "    ║               VAMOS CONVERSAR?            ║"
echo "    ╚═══════════════════════════════════════════╝"
echo -e "${RESET}"
echo

typewriter "📍 Localização: Rio de Janeiro, RJ - Brasil" 0.03 "$BOLD$BLUE"
echo

separator "─" 50 "$CYAN"

typewriter_colored "${BOLD}${YELLOW}📧 EMAIL PROFISSIONAL:${RESET}" 0.03
typewriter_colored "   ${WHITE}✉️  gabriellucas2002br@outlook.com${RESET}" 0.02
echo

typewriter_colored "${BOLD}${GREEN}📱 TELEFONE/WHATSAPP:${RESET}" 0.03
typewriter_colored "   ${WHITE}📞 +55 (21) 99801-4245${RESET}" 0.02
echo

typewriter_colored "${BOLD}${BLUE}🔗 REDES PROFISSIONAIS:${RESET}" 0.03
typewriter_colored "   ${CYAN}💼 LinkedIn:${RESET} https://www.linkedin.com/in/gabsantanna/" 0.02
typewriter_colored "   ${PURPLE}🐙 GitHub:${RESET}   https://github.com/gabriel-santanna" 0.02
typewriter_colored "   ${ORANGE}👨‍💻 Portfolio:${RESET} Em desenvolvimento..." 0.02
echo

separator "─" 50 "$CYAN"

typewriter_colored "${BOLD}${WHITE}⏰ DISPONIBILIDADE:${RESET}" 0.03
typewriter_colored "   ${GREEN}✅ Disponível para oportunidades${RESET}" 0.02
typewriter_colored "   ${GREEN}✅ Remoto, híbrido ou presencial${RESET}" 0.02
typewriter_colored "   ${GREEN}✅ Período integral ou projetos${RESET}" 0.02
echo

separator "═" 50 "$GREEN"
box "💡 Este currículo foi desenvolvido por mim em Bash!" "$BOLD$YELLOW"
typewriter_colored "${DIM}${ITALIC}\"Demonstrando habilidades técnicas de forma criativa e interativa\"${RESET}" 0.04
