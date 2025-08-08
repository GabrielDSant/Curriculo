#!/bin/bash
source utils/colors.sh

MODULOS_DIR="./modulos"

mostrar_todos() {
    clear
    for modulo in $(ls "$MODULOS_DIR" | sort); do
        bash "$MODULOS_DIR/$modulo"
        echo -e "\n${CYAN}----------------------------------------${RESET}\n"
        read -p "Pressione Enter para continuar..."
    done
}

mostrar_um() {
    clear
    echo -e "${BOLD}Selecione um módulo:${RESET}"
    select modulo in $(ls "$MODULOS_DIR" | sort) "Voltar"; do
        if [[ "$modulo" == "Voltar" ]]; then
            break
        elif [[ -n "$modulo" ]]; then
            bash "$MODULOS_DIR/$modulo"
            read -p "Pressione Enter para continuar..."
        else
            echo "Opção inválida."
        fi
    done
}

# Menu principal
while true; do
    clear
    echo -e "${BOLD}${GREEN}=== CURRÍCULO INTERATIVO ===${RESET}"
    echo "1) Ver todos os módulos"
    echo "2) Ver módulo por módulo"
    echo "3) Sair"
    read -p "Escolha uma opção: " opt

    case "$opt" in
        1) mostrar_todos ;;
        2) mostrar_um ;;
        3) exit 0 ;;
        *) echo "Opção inválida." ;;
    esac
done
