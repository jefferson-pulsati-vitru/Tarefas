#!/bin/bash

# Limpa o terminal para uma melhor visualização
clear

#
# EXECUTOR DE TESTES - NEWMAN (Linux/macOS)
#
# Este script automatiza a execução de coleções Postman usando o Newman,
# permitindo a seleção de ambientes (DEV, UAT) e a geração de relatórios.
#

# --- Caminhos dos Arquivos ---
COLLECTION="Pedagógico.postman_collection.json"
ENVIRONMENT="Enviroment.postman_environment.json"
REPORTS_DIR="relatorios"
HTML_EXTRA_REPORT="$REPORTS_DIR/relatorio-detalhado.html"
JSON_REPORT="$REPORTS_DIR/relatorio.json"
UPDATED_ENV="$REPORTS_DIR/ambiente-atualizado.json"

# --- Cores para o terminal ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Cria a pasta de relatórios se não existir
mkdir -p "$REPORTS_DIR"

# --- Funções do Script ---

# Função para instalar/atualizar as ferramentas (newman e reporter)
install_tools() {
    clear
    echo -e "${BLUE}▶️  Instalando/Atualizando newman e newman-reporter-htmlextra...${NC}"
    npm install -g newman newman-reporter-htmlextra
    echo ""
    echo -e "${GREEN}✅ Ferramentas instaladas/atualizadas com sucesso!${NC}"
    read -n 1 -s -r -p "Pressione qualquer tecla para continuar..."
}

# Função para verificar se o newman está instalado
check_newman() {
    if ! command -v newman &> /dev/null; then
        clear
        echo -e "${RED}❌ AVISO: 'newman' não foi encontrado.${NC}"
        echo -e "${YELLOW}   Ele é essencial para a execução dos testes.${NC}"
        echo ""
        read -p "Deseja instalar as ferramentas necessárias agora? (s/n): " choice
        case "$choice" in
            s|S) install_tools ;;
            *) echo -e "${RED}Operação cancelada. Não é possível continuar sem o newman.${NC}"; exit 1 ;;
        esac
    fi
}

# Função para exibir o menu de execução de testes
show_test_menu() {
    clear
    echo "---------------------------------------------"
    echo "        EXECUTOR DE TESTES - NEWMAN"
    echo "---------------------------------------------"
    echo -e "Ambiente selecionado: ${BLUE}$baseUrl${NC}"
    echo "---------------------------------------------"
    echo "[1] Executar testes simples (console)"
    echo "[2] Executar testes com relatório HTML Detalhado"
    echo "[3] Executar testes com relatório JSON"
    echo "[4] Executar testes e exportar ambiente atualizado"
    echo "[5] Voltar para seleção de ambiente"
    echo "[6] Sair"
    echo "---------------------------------------------"
    read -p "Escolha uma opção: " test_choice
}

# Função para executar os testes
run_tests() {
    local env_name=$1
    local base_newman_cmd="newman run \"$COLLECTION\" -e \"$ENVIRONMENT\" --env-var \"baseUrl=$baseUrl\" --env-var \"originUrl=$originUrl\""
    
    show_test_menu
    
    case $test_choice in
        1)
            clear
            echo -e "${BLUE}▶️  Executando testes no console...${NC}"
            eval "$base_newman_cmd"
            ;;
        2)
            clear
            local HTML_EXTRA_REPORT="$REPORTS_DIR/Relatório de Evidências - Ambiente - $env_name.html"
            echo -e "${BLUE}▶️  Executando testes com relatório HTML Detalhado...${NC}"
            eval "$base_newman_cmd -r 'cli,htmlextra' \
                --reporter-htmlextra-export '$HTML_EXTRA_REPORT' \
                --reporter-htmlextra-title 'Relatório de Testes - Card - ADF2-123' \
                --reporter-htmlextra-browserTitle 'Relatório Card - ADF2-123' \
                --reporter-htmlextra-darkTheme \
                --reporter-htmlextra-skipHeaders 'Authorization' \
                --reporter-htmlextra-displayProgressBar"
            echo -e "${GREEN}✅ Relatório gerado em: $HTML_EXTRA_REPORT${NC}"
            ;;
        3)
            clear
            local JSON_REPORT="$REPORTS_DIR/Relatorio-$env_name.json"
            echo -e "${BLUE}▶️  Executando testes com relatório JSON...${NC}"
            eval "$base_newman_cmd -r json --reporter-json-export '$JSON_REPORT'"
            echo -e "${GREEN}✅ Relatório gerado em: $JSON_REPORT${NC}"
            ;;
        4)
            clear
            local UPDATED_ENV="$REPORTS_DIR/Ambiente-atualizado-$env_name.json"
            echo -e "${BLUE}▶️  Executando testes e exportando ambiente atualizado...${NC}"
            eval "$base_newman_cmd --export-environment '$UPDATED_ENV'"
            echo -e "${GREEN}✅ Ambiente exportado para: $UPDATED_ENV${NC}"
            ;;
        5) return ;; # Retorna para o menu de ambiente
        6) clear; echo "Encerrando..."; exit 0 ;;
        *) echo -e "${RED}❌ Opção inválida.${NC}" ;;
    esac
    read -n 1 -s -r -p "Pressione qualquer tecla para voltar ao menu de testes..."
    run_tests "$env_name" # Loop no menu de testes
}


# --- Fluxo Principal do Script ---

# 1. Verifica se as ferramentas estão instaladas
check_newman

# 2. Loop principal para seleção de ambiente
while true; do
    clear
    echo "---------------------------------------------"
    echo "     SELECIONE O AMBIENTE DE EXECUCAO"
    echo "---------------------------------------------"
    echo "[1] Desenvolvimento (DEV)"
    echo "[2] Homologação (UAT)"
    echo "[3] Instalar/Atualizar Ferramentas"
    echo "[4] Sair"
    echo "---------------------------------------------"
    read -p "Escolha uma opção: " env_choice

    case $env_choice in
        1)
            env_name="DEV"
            baseUrl="https://mundoazul-dev.unicesumar.edu.br"
            originUrl="https://mundoazul-dev.unicesumar.edu.br"
            run_tests "$env_name"
            ;;
        2)
            env_name="UAT"
            baseUrl="https://gateway-uat.unicesumar.edu.br"
            originUrl="https://mundoazul-uat.unicesumar.edu.br"
            run_tests "$env_name"
            ;;
        3)
            install_tools
            ;;
        4)
            clear
            echo "Encerrando..."
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Opção inválida. Tente novamente.${NC}"
            sleep 1
            ;;
    esac
done 