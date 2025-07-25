# PostgreSQL com PostGIS e pgvector

Esta é uma imagem Docker personalizada do PostgreSQL construída a partir da imagem oficial do PostgreSQL, com instalação manual das extensões PostGIS e pgvector. Disponível no [DockerHub](https://hub.docker.com/r/garapadev/postgres-postgis-pgvector) em várias versões otimizadas.

## 🚀 Uso Rápido

### Via DockerHub (Recomendado)
```bash
# Versão otimizada (recomendada - 808MB)
docker pull garapadev/postgres-postgis-pgvector:16-optimized

# Versão completa (2.82GB)
docker pull garapadev/postgres-postgis-pgvector:latest

# Executar
docker run -d \
  --name postgres-pgvector-postgis \
  -e POSTGRES_DB=mydb \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  garapadev/postgres-postgis-pgvector:16-optimized
```

### Com docker-compose
```bash
# Clonar o repositório
git clone <repository-url>
cd postgres_postgis_pgvector

# Iniciar ambiente completo
docker-compose up -d
```

## 📦 Versões Disponíveis

| Tag | Tamanho | Descrição | Uso Recomendado |
|-----|---------|-----------|-----------------|
| `16-optimized` | 808MB | Versão otimizada com multi-stage build | **Produção** |
| `15-optimized` | 902MB | PostgreSQL 15 otimizada **[CORRIGIDA]** | **Produção** |
| `15-stable` | 902MB | PostgreSQL 15 estável **[CORRIGIDA]** | Produção estável |
| `15-slim` | 902MB | PostgreSQL 15 compacta **[CORRIGIDA]** | Produção |
| `15` | 2.91GB | PostgreSQL 15 completa **[CORRIGIDA]** | Desenvolvimento |
| `latest` | 2.82GB | Versão completa com todas as dependências | Desenvolvimento |
| `stable` | 2.82GB | Versão estável (mesmo que latest) | Produção estável |
| `16` | 2.82GB | PostgreSQL 16 específico | Compatibilidade |

### 🔧 Correções Aplicadas (PostgreSQL 15)

**IMPORTANTE**: As versões do PostgreSQL 15 foram corrigidas em 2024 para resolver problemas de inicialização do pgvector.

- **Problema**: Script de inicialização falhava com erro "database 'mydb' does not exist"
- **Causa**: Comando `\c mydb` hardcoded no script SQL
- **Solução**: Removido comando de conexão específica, permitindo uso com qualquer nome de banco
- **Resultado**: pgvector agora inicializa corretamente em todas as versões do PostgreSQL 15

## 🛠️ Desenvolvimento Local

### Usando Make (Recomendado)
```bash
make help           # Ver todos os comandos
make dev            # Ambiente completo de desenvolvimento
make test           # Testar funcionalidades
make clean          # Limpar ambiente
```

### Comandos Docker Manuais
```bash
# Build da imagem otimizada
./scripts/build.sh

# Ou build manual
docker build -f docker/Dockerfile.optimized -t garapadev/postgres-postgis-pgvector:16-optimized .
## 🧪 Características Técnicas

- **PostgreSQL 16.9** - Imagem oficial do PostgreSQL
- **PostGIS 3.4.2** - Compilado manualmente para melhor compatibilidade
- **pgvector 0.7.4** - Extensão para armazenamento e busca de vetores
- **GEOS, PROJ, GDAL** - Bibliotecas geoespaciais atualizadas
- **Extensões incluídas**: postgis, postgis_topology, fuzzystrmatch, vector

## 🔧 Conexão

### Informações de Conexão
- **Host**: localhost
- **Porta**: 5432
- **Banco**: mydb
- **Usuário**: postgres
- **Senha**: postgres
- **String de conexão**: `postgresql://postgres:postgres@localhost:5432/mydb`

### PgAdmin (Opcional)
- **URL**: http://localhost:8080
- **Email**: admin@exemplo.com
- **Senha**: admin

## 🧪 Extensões Disponíveis

Após a inicialização, as seguintes extensões estarão disponíveis:

- `postgis` - Funcionalidades geoespaciais básicas
- `postgis_topology` - Suporte a topologia
- `fuzzystrmatch` - Funções de correspondência difusa
- `postgis_tiger_geocoder` - Geocodificação TIGER
- `vector` - Armazenamento e operações com vetores

## Exemplos de uso

### PostGIS - Dados geoespaciais

```sql
-- Criar uma tabela com geometria
CREATE TABLE locais (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    ponto GEOMETRY(POINT, 4326)
);

-- Inserir um ponto
INSERT INTO locais (nome, ponto) 
VALUES ('São Paulo', ST_SetSRID(ST_MakePoint(-46.6333, -23.5505), 4326));

-- Buscar pontos próximos (raio de 1000 metros)
SELECT nome, ST_AsText(ponto)
FROM locais 
WHERE ST_DWithin(
    ponto, 
    ST_SetSRID(ST_MakePoint(-46.6333, -23.5505), 4326), 
    1000
);
```

### pgvector - Vetores de embeddings

```sql
-- Criar uma tabela com vetores
CREATE TABLE documentos (
    id SERIAL PRIMARY KEY,
    conteudo TEXT,
    embedding VECTOR(1536)
);

-- Inserir um documento com embedding
INSERT INTO documentos (conteudo, embedding) 
VALUES ('Exemplo de texto', '[0.1, 0.2, 0.3, ...]'::vector);

-- Buscar documentos similares usando cosine distance
SELECT conteudo, embedding <=> '[0.1, 0.2, 0.3, ...]'::vector AS distancia
FROM documentos
ORDER BY embedding <=> '[0.1, 0.2, 0.3, ...]'::vector
LIMIT 5;
```

## Administração

### PgAdmin (Interface Web)

Se você usou o docker-compose, o PgAdmin estará disponível em:
- **URL**: http://localhost:8080
- **Email**: admin@exemplo.com
- **Senha**: admin

### Backup e Restore

```bash
# Backup
docker exec postgres-pgvector-postgis pg_dump -U postgres mydb > backup.sql

# Restore
docker exec -i postgres-pgvector-postgis psql -U postgres mydb < backup.sql
```

## Personalização

### Variáveis de ambiente

Você pode personalizar a configuração através das seguintes variáveis de ambiente:

- `POSTGRES_DB` - Nome do banco de dados (padrão: mydb)
- `POSTGRES_USER` - Usuário do PostgreSQL (padrão: postgres)
- `POSTGRES_PASSWORD` - Senha do PostgreSQL (padrão: postgres)

### Volumes persistentes

O docker-compose já configura um volume persistente para os dados. Os dados ficam armazenados no volume `postgres_data`.

## Troubleshooting

### Verificar se as extensões estão instaladas

```sql
SELECT extname, extversion FROM pg_extension;
```

## 🔍 Verificações e Debug

### Verificar logs do container
```bash
docker-compose logs -f postgres-pgvector-postgis
# ou
make logs
```

### Conectar ao container
```bash
docker exec -it postgres-pgvector-postgis psql -U postgres -d mydb
```

### Testar extensões
```bash
# Testar tudo automaticamente
make test

# Ou testar manualmente
docker exec postgres-pgvector-postgis psql -U postgres -d mydb -c "SELECT PostGIS_Full_Version();"
```

## 📁 Estrutura do Projeto

```
postgres_postgis_pgvector/
├── docker/                 # Dockerfiles alternativos
│   └── Dockerfile.optimized
├── scripts/                # Scripts de build e deploy
│   ├── build.sh
│   ├── build.bat
│   ├── publish.sh
│   └── publish.bat
├── sql/                    # Scripts SQL
│   └── init.sql
├── backups/                # Pasta para backups
├── Dockerfile              # Dockerfile principal
├── docker-compose.yml      # Orquestração dos containers
├── config.env             # Configurações do ambiente
├── Makefile               # Comandos automatizados
├── DEVELOPMENT.md          # Guia de desenvolvimento
└── README.md              # Esta documentação
```

## 📚 Documentação Adicional

- [DEVELOPMENT.md](DEVELOPMENT.md) - Guia detalhado de desenvolvimento
- [DockerHub](https://hub.docker.com/r/garapadev/postgres-postgis-pgvector) - Imagens publicadas

## 📄 Licença

Este projeto é baseado nas imagens oficiais do PostgreSQL e PostGIS, seguindo suas respectivas licenças.
