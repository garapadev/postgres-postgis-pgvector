# Guia de Desenvolvimento

## 🛠️ Configuração do Ambiente

### Pré-requisitos
- Docker Desktop instalado
- Git configurado
- Make (opcional, para comandos simplificados)

### Estrutura do Projeto
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
└── README.md              # Documentação principal
```

## 🚀 Comandos Rápidos

### Com Make (recomendado)
```bash
make help           # Ver todos os comandos
make dev            # Ambiente completo de desenvolvimento
make test           # Testar funcionalidades
make clean          # Limpar ambiente
```

### Comandos Docker Manuais
```bash
# Build da imagem otimizada
docker build -f docker/Dockerfile.optimized -t garapadev/postgres-postgis-pgvector:16-optimized .

# Subir ambiente
docker-compose up -d

# Testar extensões
docker exec postgres-pgvector-postgis psql -U postgres -d mydb -c "SELECT PostGIS_Full_Version();"
```

## 🧪 Testes

### PostgreSQL
```sql
SELECT version();
```

### PostGIS
```sql
SELECT PostGIS_Full_Version();
CREATE EXTENSION IF NOT EXISTS postgis;
```

### pgvector
```sql
SELECT * FROM pg_available_extensions WHERE name = 'vector';
CREATE EXTENSION IF NOT EXISTS vector;
```

## 📝 Logs

Para acompanhar os logs:
```bash
docker-compose logs -f postgres-pgvector-postgis
```

## 🔧 Troubleshooting

### Container não inicia
1. Verificar se a porta 5432 está livre
2. Verificar logs: `docker-compose logs`
3. Resetar volumes: `docker-compose down -v`

### Extensões não funcionam
1. Verificar se as extensões foram compiladas corretamente
2. Verificar logs de build
3. Testar com `\dx` no psql

## 📦 Deploy

Para fazer deploy no DockerHub:
```bash
./scripts/publish.sh
```

Ou usar o Makefile:
```bash
make publish
```
