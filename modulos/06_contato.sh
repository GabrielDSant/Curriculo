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

echo -e "${BOLD}${YELLOW}📧 EMAIL PROFISSIONAL:${RESET}"
echo -e "   ${WHITE}✉️  gabriellucas2002br@outlook.com${RESET}"
echo

echo -e "${BOLD}${GREEN}📱 TELEFONE/WHATSAPP:${RESET}"
echo -e "   ${WHITE}📞 +55 (21) 99801-4245${RESET}"
echo

echo -e "${BOLD}${BLUE}🔗 REDES PROFISSIONAIS:${RESET}"
echo -e "   ${CYAN}💼 LinkedIn:${RESET} https://www.linkedin.com/in/gabsantanna/"
echo -e "   ${PURPLE}🐙 GitHub:${RESET}   https://github.com/gabriel-santanna"
echo -e "   ${ORANGE}👨‍💻 Portfolio:${RESET} Em desenvolvimento..."
echo

separator "─" 50 "$CYAN"

echo -e "${BOLD}${WHITE}⏰ DISPONIBILIDADE:${RESET}"
echo -e "   ${GREEN}✅ Disponível para oportunidades${RESET}"
echo -e "   ${GREEN}✅ Remoto, híbrido ou presencial${RESET}"
echo -e "   ${GREEN}✅ Período integral ou projetos${RESET}"
echo

separator "═" 50 "$GREEN"
box "💡 Este currículo foi desenvolvido por mim em Bash!" "$BOLD$YELLOW"
echo -e "${DIM}${ITALIC}\"Demonstrando habilidades técnicas de forma criativa e interativa\"${RESET}"
