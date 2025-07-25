#!/bin/bash

# Script para construir e executar a imagem PostgreSQL personalizada

set -e

echo "🐳 Construindo imagem PostgreSQL com PostGIS e pgvector..."

# Construir a imagem
docker build -t garapadev/postgres-postgis-pgvector:latest .

echo "✅ Imagem construída com sucesso!"

# Opção para executar imediatamente
read -p "Deseja executar o container agora? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Iniciando containers com docker-compose..."
    docker-compose up -d
    
    echo "⏳ Aguardando o PostgreSQL ficar pronto..."
    sleep 10
    
    echo "✅ PostgreSQL está rodando!"
    echo "📋 Informações de conexão:"
    echo "   Host: localhost"
    echo "   Porta: 5432"
    echo "   Banco: mydb"
    echo "   Usuário: postgres"
    echo "   Senha: postgres"
    echo ""
    echo "🌐 PgAdmin disponível em: http://localhost:8080"
    echo "   Email: admin@exemplo.com"
    echo "   Senha: admin"
    echo ""
    echo "🔗 String de conexão:"
    echo "   postgresql://postgres:postgres@localhost:5432/mydb"
fi
