#!/bin/bash
source utils/colors.sh

clear
box "🛠️  TECNOLOGIAS & HABILIDADES" "$BOLD$BLUE"
echo

mostrar_tecnologia() {
    local nome="$1"
    local arquivo_ascii="$2"
    local descricao="$3"
    local nivel="$4"
    local cor="$5"
    
    echo
    separator "─" 60 "$CYAN"
    typewriter "🔧 $nome" 0.05 "$BOLD$cor"
    echo
    
    if [[ -f "ascii/$arquivo_ascii" ]]; then
        cat "ascii/$arquivo_ascii"
    fi
    
    echo -e "${WHITE}📝 $descricao${RESET}"
    
    # Barra de progresso do nível
    echo -ne "${BOLD}⭐ Nível: ${RESET}"
    for ((i=1; i<=5; i++)); do
        if [[ $i -le $nivel ]]; then
            echo -ne "${GREEN}█${RESET}"
        else
            echo -ne "${DIM}░${RESET}"
        fi
    done
    echo -e " ${BOLD}($nivel/5)${RESET}"
    echo
}

# Apresentação das tecnologias com animações
loading 2 "Carregando stack de tecnologias" "$CYAN"

mostrar_tecnologia "Docker & Containerização" "docker.txt" \
    "Criação e gerenciamento de containers, Docker Compose, otimização de images" \
    4 "$CYAN"

mostrar_tecnologia "Oracle Database & PL/SQL" "oracle.txt" \
    "Desenvolvimento de procedures, functions, triggers e otimização de queries" \
    4 "$RED"

mostrar_tecnologia "Sistemas Linux" "linux.txt" \
    "Administração de servidores, shell scripting, automação e troubleshooting" \
    5 "$YELLOW"

mostrar_tecnologia "PHP Development" "php.txt" \
    "Desenvolvimento backend, APIs REST, frameworks e integração com bancos" \
    4 "$MAGENTA"

mostrar_tecnologia "Amazon Web Services (AWS)" "aws.txt" \
    "EC2, S3, RDS, Lambda, CloudFormation e arquiteturas serverless" \
    3 "$ORANGE"

mostrar_tecnologia "Ansible Automation" "ansible.txt" \
    "Automação de infraestrutura, playbooks, roles e configuração de servidores" \
    3 "$YELLOW"

echo
box "🎯 DESTAQUE: Combinação única de desenvolvimento e infraestrutura!" "$BOLD$GREEN"