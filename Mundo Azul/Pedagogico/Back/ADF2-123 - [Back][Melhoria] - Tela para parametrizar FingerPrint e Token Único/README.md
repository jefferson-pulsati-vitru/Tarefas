# Projeto de Testes de API - Parametrização de Fingerprint e Token Único

Este projeto contém os testes automatizados para as APIs de gerenciamento de Fingerprint e Token Único dos polos no módulo Pedagógico do Mundo Azul.

## 🔎 Escopo
- **Projeto**: MundoAzul
- **Camada**: Back-End
- **Ferramentas**: Postman + Newman
- **Ambientes**: DEV e UAT

## 📂 Estrutura de Arquivos
- `Collection/`: Contém a collection do Postman (`ADF2-123.postman_collection.json`) com os cenários de teste.
- `Enviroment/`: Contém o arquivo de ambiente do Postman (`Enviroment.postman_environment.json`).
- `Relatorios/`: Pasta onde os relatórios de evidência em HTML são gerados.
- `executar-testes.bat`: Script para facilitar a execução dos testes em ambiente Windows.
- `executar-testes.sh`: Script para facilitar a execução dos testes em ambiente Linux/macOS.

## 📋 Pré-requisitos

- **[Node.js](https://nodejs.org/)** (que inclui o `npm`).
  O `Node.js` é necessário para a instalação do `Newman`, a ferramenta de linha de comando que executa as collections do Postman.

## 🚀 Como Executar os Testes

A execução é feita de forma interativa através dos scripts `executar-testes.bat` (para Windows) ou `executar-testes.sh` (para Linux/macOS).

1.  **Abra um terminal** na pasta raiz do projeto.

2.  **Execute o script** correspondente ao seu sistema operacional:
    -   No Windows: `.\\executar-testes.bat`
    -   No Linux/macOS: `bash executar-testes.sh`

3.  **Instale as dependências (primeira vez):**
    -   No menu principal, escolha a opção `[3] Instalar/Atualizar Ferramentas`.
    -   Isso instalará o `Newman` e o `newman-reporter-htmlextra` globalmente em sua máquina.

4.  **Selecione o Ambiente:**
    -   Escolha entre `[1] Desenvolvimento (DEV)` ou `[2] Homologação (UAT)`.

5.  **Escolha o Tipo de Execução:**
    -   Após selecionar o ambiente, um novo menu aparecerá. Você pode escolher executar os testes e ver o resultado no console, gerar um relatório HTML detalhado, entre outras opções.

## 🚫 Segurança e Configuração
**IMPORTANTE:** As credenciais de acesso (`username` e `password`) foram intencionalmente deixadas em branco no arquivo `Enviroment/Enviroment.postman_environment.json` por motivos de segurança.

Para que os testes executem com sucesso, **você precisa preencher esses campos com um usuário e senha válidos** para o ambiente (DEV ou UAT) que deseja testar.

## ⛓️ Endpoints Testados
-   `GET → /mundoazul-api-studeo/api/polo/fingerprint`
-   `POST → /mundoazul-api-studeo/api/polo/fingerprint`
-   `POST → /mundoazul-api-studeo/api/polo/token-unico/`

## 📊 Cenários de Teste
A suíte de testes é composta por um total de 17 cenários:
-   **GET:** 9 cenários
-   **POST:** 8 cenários

## ✅ Principais Validações

### Método GET
-   Verifica se o Status Code da resposta é `200 OK`.
-   Verifica se o tempo de resposta da API é inferior a 3 segundos.

### Método POST
-   Verifica se o Status Code da resposta é `202 Accepted`.
-   Verifica se o tempo de resposta da API é inferior a 3 segundos.

## 📄 Relatórios
Os relatórios de evidência da execução dos testes são gerados na pasta `Relatorios/` ao escolher a opção de execução com relatório HTML. 