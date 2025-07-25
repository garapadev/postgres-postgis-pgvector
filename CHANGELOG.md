# Changelog

## [1.4.0] - 2025-01-20

### 🔧 **PostgreSQL 16 - Correção Dupla: SQL + Otimização Docker**

### ✅ Fixed
- **CRÍTICO**: Corrigidos múltiplos problemas no PostgreSQL 16
  - **Problema SQL**: Mesma falha de inicialização do PostgreSQL 15 (comando `\c mydb` hardcoded)
  - **Problema Docker**: Otimização removendo bibliotecas runtime essenciais do PostGIS
    - `libgeos-c1v5`, `libproj25`, `libgdal32` necessárias para operações geoespaciais
    - Erro: `libgeos_c.so.1: cannot open shared object file`
  - **Solução Integrada**: 
    - Script SQL: Uso do `sql/init.sql` já corrigido
    - Dockerfile optimizado: Preservação de dependências runtime while removendo apenas desenvolvimento

### 📦 Updated
- Republicadas todas as versões do PostgreSQL 16 corrigidas:
  - `garapadev/postgres-postgis-pgvector:16` (2.82GB) - Versão completa
  - `garapadev/postgres-postgis-pgvector:16-optimized` (977MB) - Versão otimizada com runtime deps
  - `garapadev/postgres-postgis-pgvector:16-stable` (977MB) - Alias da versão otimizada
  - `garapadev/postgres-postgis-pgvector:16-slim` (977MB) - Alias da versão otimizada
  - `garapadev/postgres-postgis-pgvector:latest` → PostgreSQL 16 (padrão)
  - `garapadev/postgres-postgis-pgvector:stable` → PostgreSQL 16 (padrão)

## [1.3.0] - 2025-01-20

### 🔧 **PostgreSQL 15 - Correção Crítica de Inicialização**

### ✅ Fixed
- **CRÍTICO**: Corrigido erro de inicialização do pgvector no PostgreSQL 15
  - Problema: Script falhava com "database 'mydb' does not exist"
  - Causa: Comando `\c mydb` hardcoded em `sql/init.sql`
  - Solução: Removido comando de conexão específica
  - Resultado: pgvector agora funciona com qualquer nome de banco definido em `POSTGRES_DB`

### 📦 Updated
- Republicadas todas as versões do PostgreSQL 15 corrigidas:
  - `garapadev/postgres-postgis-pgvector:15` (2.91GB)
  - `garapadev/postgres-postgis-pgvector:15-optimized` (902MB)
  - `garapadev/postgres-postgis-pgvector:15-stable` (902MB)
  - `garapadev/postgres-postgis-pgvector:15-slim` (902MB)

### ✅ Tested
- Verificado funcionamento do pgvector: `SELECT '[1,2,3]'::vector <-> '[4,5,6]'::vector`
- Confirmado PostGIS funcionando corretamente
- Testado inicialização com diferentes nomes de banco

## [1.2.0] - 2025-01-20

### 🎯 **Projeto Sanitizado e Reorganizado**

### ✅ Added
- Estrutura de pastas organizada (`docker/`, `scripts/`, `sql/`)
- `Makefile` com comandos automatizados
- `config.env` para configurações centralizadas
- `DEVELOPMENT.md` com guia de desenvolvimento
- Versão otimizada como padrão no docker-compose

### ♻️ Changed
- Reorganizada estrutura do projeto
- Docker-compose atualizado para usar imagem otimizada
- Scripts movidos para pasta `scripts/`
- SQLs movidos para pasta `sql/`
- Dockerfiles movidos para pasta `docker/`
- README.md completamente reescrito e simplificado

### 🗑️ Removed
- Todos os arquivos Alpine (Dockerfile.alpine*, build-alpine.sh, etc.)
- Arquivos de documentação temporários (CLEANUP.md, TAGS.md)
- Scripts de comparação desnecessários
- Duplicações no README.md

### 📦 Deploy
- **Imagens publicadas no DockerHub:**
  - `garapadev/postgres-postgis-pgvector:latest` (2.82GB)
  - `garapadev/postgres-postgis-pgvector:16-optimized` (808MB) ⭐ **Recomendada**
  - `garapadev/postgres-postgis-pgvector:stable` (2.82GB)
  - `garapadev/postgres-postgis-pgvector:16` (2.82GB)

---

## [1.1.0] - 2025-01-20

### ✅ Added
- Versão Debian funcional
- Dockerfile.optimized com multi-stage build
- Suporte completo a PostGIS 3.4.2 e pgvector 0.7.4

### ❌ Removed
- Suporte ao Alpine Linux (problemas de compilação)

---

## [1.0.0] - 2025-01-20

### ✅ Added
- Primeira versão com PostgreSQL 16 + PostGIS + pgvector
- Dockerfile inicial
- Scripts de build básicos
- docker-compose.yml
