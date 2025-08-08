# Cores básicas
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
BOLD="\033[1m"
RESET="\033[0m"

# Função para imprimir com cor
color_echo() {
    local color="$1"
    shift
    echo -e "${color}$*${RESET}"
}
