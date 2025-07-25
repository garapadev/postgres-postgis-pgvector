#!/bin/bash

# Script para publicar PostgreSQL 15 no DockerHub

set -e

IMAGE_NAME="garapadev/postgres-postgis-pgvector"
PG_VERSION="15"

echo "📤 Publicando PostgreSQL ${PG_VERSION} no DockerHub..."

# Verificar se as imagens existem
if ! docker image inspect ${IMAGE_NAME}:${PG_VERSION} &> /dev/null; then
    echo "❌ Imagem ${IMAGE_NAME}:${PG_VERSION} não encontrada!"
    echo "Execute primeiro: ./scripts/build-pg15.sh"
    exit 1
fi

# Login no DockerHub
echo "🔐 Fazendo login no DockerHub..."
docker login

# Push das imagens
echo "⬆️  Fazendo push das imagens PostgreSQL ${PG_VERSION}..."
docker push ${IMAGE_NAME}:${PG_VERSION}
docker push ${IMAGE_NAME}:${PG_VERSION}-optimized
docker push ${IMAGE_NAME}:${PG_VERSION}-postgis-pgvector
docker push ${IMAGE_NAME}:${PG_VERSION}-slim

echo "✅ Push concluído com sucesso!"
echo ""
echo "🌐 Imagens PostgreSQL ${PG_VERSION} disponíveis em:"
echo "   🐳 Versão completa:"
echo "      docker pull ${IMAGE_NAME}:${PG_VERSION}"
echo "   📦 Versão otimizada (recomendada):"
echo "      docker pull ${IMAGE_NAME}:${PG_VERSION}-optimized"
echo "   🎯 Tags específicas:"
echo "      docker pull ${IMAGE_NAME}:${PG_VERSION}-postgis-pgvector"
echo "      docker pull ${IMAGE_NAME}:${PG_VERSION}-slim"
