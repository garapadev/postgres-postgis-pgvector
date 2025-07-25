# Diretório para backups

Este diretório é usado para armazenar backups do banco de dados.

## Como fazer backup

```bash
# Backup completo
docker exec postgres-pgvector-postgis pg_dump -U postgres mydb > backups/backup_$(date +%Y%m%d_%H%M%S).sql

# Backup comprimido
docker exec postgres-pgvector-postgis pg_dump -U postgres mydb | gzip > backups/backup_$(date +%Y%m%d_%H%M%S).sql.gz
```

## Como restaurar

```bash
# Restaurar backup
docker exec -i postgres-pgvector-postgis psql -U postgres mydb < backups/backup_20240101_120000.sql

# Restaurar backup comprimido
gunzip -c backups/backup_20240101_120000.sql.gz | docker exec -i postgres-pgvector-postgis psql -U postgres mydb
```
