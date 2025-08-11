# Cores básicas
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[1;37m"
BOLD="\033[1m"
DIM="\033[2m"
UNDERLINE="\033[4m"
BLINK="\033[5m"
REVERSE="\033[7m"
RESET="\033[0m"

# Cores de fundo
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_BLUE="\033[44m"
BG_MAGENTA="\033[45m"
BG_CYAN="\033[46m"

# Cores RGB mais modernas
ORANGE="\033[38;5;208m"
PURPLE="\033[38;5;129m"
LIME="\033[38;5;154m"
PINK="\033[38;5;198m"

# Função para imprimir com cor
color_echo() {
    local color="$1"
    shift
    echo -e "${color}$*${RESET}"
}

# Função para criar separadores estilizados
separator() {
    local char="${1:-=}"
    local length="${2:-50}"
    local color="${3:-$CYAN}"
    printf "${color}"
    printf "%*s\n" "$length" | tr ' ' "$char"
    printf "${RESET}"
}

# Função para criar uma caixa ao redor do texto
box() {
    local text="$1"
    local color="${2:-$GREEN}"
    local length=$((${#text} + 4))
    
    echo -e "${color}"
    printf "┌"
    printf "%*s" "$((length-2))" | tr ' ' '─'
    printf "┐\n"
    printf "│ %-*s │\n" "$((length-4))" "$text"
    printf "└"
    printf "%*s" "$((length-2))" | tr ' ' '─'
    printf "┘\n"
    echo -e "${RESET}"
}

# Função para criar efeito de digitação
typewriter() {
    local text="$1"
    local delay="${2:-0.05}"
    local color="${3:-$WHITE}"
    
    echo -ne "${color}"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:$i:1}"
        sleep "$delay"
    done
    echo -e "${RESET}"
}

# Função typewriter aprimorada para textos com cores
typewriter_colored() {
    local text="$1"
    local delay="${2:-0.03}"
    
    # Primeiro aplica as cores usando echo -e e captura o resultado
    local colored_text
    colored_text=$(echo -e "$text")
    
    # Aplica o efeito typewriter usando um loop simples
    for (( i=0; i<${#colored_text}; i++ )); do
        char="${colored_text:$i:1}"
        printf "%s" "$char"
        
        # Adiciona delay apenas para caracteres alfabéticos, numéricos e símbolos visíveis
        if [[ "$char" =~ [A-Za-z0-9[:punct:]🚀🎓💼▶📚🎯🏢⭐] ]]; then
            sleep "$delay"
        fi
    done
    echo
}

# Função para criar loading animado
loading() {
    local duration="${1:-3}"
    local message="${2:-Carregando}"
    local color="${3:-$CYAN}"
    
    echo -ne "${color}${message} "
    for ((i=0; i<duration; i++)); do
        for char in '|' '/' '-' '\'; do
            echo -ne "\b$char"
            sleep 0.1
        done
    done
    echo -e "\b ✓${RESET}"
}
