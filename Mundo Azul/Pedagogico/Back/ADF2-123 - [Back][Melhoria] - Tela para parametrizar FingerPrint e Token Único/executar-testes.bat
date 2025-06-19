@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Caminhos dos arquivos
set "COLLECTION=Collection\ADF2-123.postman_collection.json"
set "ENVIRONMENT=Enviroment\Enviroment.postman_environment.json"
set "HTML_EXTRA_REPORT=Relatorios\Relatorio-detalhado.html"

:: Cria a pasta de relatórios se não existir
if not exist "Relatorios" mkdir "Relatorios"

:ENV_MENU
cls
echo ---------------------------------------------
echo      SELECIONE O AMBIENTE DE EXECUCAO
echo ---------------------------------------------
echo [1] Desenvolvimento (DEV)
echo [2] Homologacao (UAT)
echo [3] Instalar/Atualizar Ferramentas
echo [4] Sair
echo ---------------------------------------------
set /p env_choice="Escolha uma opção: "

if "%env_choice%"=="1" set "env_name=DEV" & set "baseUrl=https://mundoazul-dev.unicesumar.edu.br" & set "originUrl=https://mundoazul-dev.unicesumar.edu.br" & goto CHECK_NEWMAN
if "%env_choice%"=="2" set "env_name=UAT" & set "baseUrl=https://gateway-uat.unicesumar.edu.br" & set "originUrl=https://mundoazul-uat.unicesumar.edu.br" & goto CHECK_NEWMAN
if "%env_choice%"=="3" goto INSTALL_REPORTER
if "%env_choice%"=="4" goto FIM

echo ❌ Opção inválida. Pressione qualquer tecla para tentar novamente.
pause >nul
goto ENV_MENU

:CHECK_NEWMAN
where newman >nul 2>nul
if %errorlevel% neq 0 (
    cls
    echo ❌ AVISO: 'newman' não foi encontrado ou não está no PATH.
    echo    Ele é essencial para a execução dos testes.
    echo.
    echo    Por favor, retorne ao menu anterior e utilize a opção [3]
    echo    para instalar as ferramentas necessárias.
    echo.
    pause
    goto ENV_MENU
)
goto MENU

:MENU
cls
echo ---------------------------------------------
echo         EXECUTOR DE TESTES - NEWMAN
echo ---------------------------------------------
echo Ambiente selecionado: %baseUrl%
echo ---------------------------------------------
echo [1] Executar testes simples (console)
echo [2] Executar testes com relatorio HTML Detalhado
echo [3] Executar testes com relatorio JSON
echo [4] Executar testes e exportar ambiente atualizado
echo [5] Voltar para seleção de ambiente
echo [6] Sair
echo ---------------------------------------------
set /p opcao="Escolha uma opção: "

if "%opcao%"=="1" goto RUN_SIMPLE
if "%opcao%"=="2" goto RUN_HTML_EXTRA
if "%opcao%"=="3" goto RUN_JSON
if "%opcao%"=="4" goto RUN_EXPORT
if "%opcao%"=="5" goto ENV_MENU
if "%opcao%"=="6" goto FIM

echo ❌ Opção inválida. Pressione qualquer tecla para tentar novamente.
pause >nul
goto MENU

:CHECK_FILES
if not exist "%COLLECTION%" (
    echo ❌ ERRO: Arquivo da collection não encontrado: %COLLECTION%
    pause
    goto MENU
)
if not exist "%ENVIRONMENT%" (
    echo ❌ ERRO: Arquivo do ambiente não encontrado: %ENVIRONMENT%
    pause
    goto MENU
)
goto CONTINUE

:RUN_SIMPLE
call :CHECK_FILES
:CONTINUE
cls
echo ▶️  Executando testes no console...
newman run "%COLLECTION%" -e "%ENVIRONMENT%" --env-var "baseUrl=%baseUrl%" --env-var "originUrl=%originUrl%"
pause
goto MENU

:RUN_HTML_EXTRA
call :CHECK_FILES
cls
echo ▶️  Executando testes com relatorio HTML Detalhado...
set "HTML_EXTRA_REPORT=Relatorios\Relatório de Evidências - Ambiente - %env_name%.html"
newman run "%COLLECTION%" -e "%ENVIRONMENT%" --env-var "baseUrl=%baseUrl%" --env-var "originUrl=%originUrl%" -r "cli,htmlextra" --reporter-htmlextra-export "%HTML_EXTRA_REPORT%" --reporter-htmlextra-title "Relatório de Testes - Card ADF2-123" --reporter-htmlextra-browserTitle "Relatório Card ADF2-123" --reporter-htmlextra-darkTheme --reporter-htmlextra-skipHeaders "Authorization" --reporter-htmlextra-displayProgressBar
echo ✅ Relatorio gerado em: %HTML_EXTRA_REPORT%
pause
goto MENU

:RUN_JSON
call :CHECK_FILES
cls
echo ▶️  Executando testes com relatorio JSON...
set "JSON_REPORT=Relatorios\Relatorio-%env_name%.json"
newman run "%COLLECTION%" -e "%ENVIRONMENT%" --env-var "baseUrl=%baseUrl%" --env-var "originUrl=%originUrl%" -r json --reporter-json-export "%JSON_REPORT%"
echo ✅ Relatorio gerado em: %JSON_REPORT%
pause
goto MENU

:RUN_EXPORT
call :CHECK_FILES
cls
echo ▶️  Executando testes e exportando ambiente atualizado...
set "UPDATED_ENV=Relatorios\Ambiente-atualizado-%env_name%.json"
newman run "%COLLECTION%" -e "%ENVIRONMENT%" --env-var "baseUrl=%baseUrl%" --env-var "originUrl=%originUrl%" --export-environment "%UPDATED_ENV%"
echo ✅ Ambiente exportado para: %UPDATED_ENV%
pause
goto MENU

:INSTALL_REPORTER
cls
echo ▶️  Instalando/Atualizando newman e newman-reporter-htmlextra...
npm install -g newman newman-reporter-htmlextra
echo.
echo ✅ Ferramentas instaladas/atualizadas com sucesso!
pause
goto ENV_MENU

:FIM
echo Encerrando...
endlocal
exit
