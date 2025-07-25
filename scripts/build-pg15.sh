#!/bin/bash

# Script para construir PostgreSQL 15 com PostGIS e pgvector

set -e

IMAGE_NAME="garapadev/postgres-postgis-pgvector"
PG_VERSION="15"

echo "🐳 Construindo PostgreSQL ${PG_VERSION} com PostGIS e pgvector..."

# Construir versão padrão
echo "🔨 Construindo versão padrão..."
docker build -f docker/Dockerfile.pg15 -t ${IMAGE_NAME}:${PG_VERSION} .

# Construir versão otimizada
echo "🔨 Construindo versão otimizada..."
docker build -f docker/Dockerfile.pg15-optimized -t ${IMAGE_NAME}:${PG_VERSION}-optimized .

# Criar tags adicionais
echo "🏷️  Criando tags adicionais..."
docker tag ${IMAGE_NAME}:${PG_VERSION} ${IMAGE_NAME}:${PG_VERSION}-postgis-pgvector
docker tag ${IMAGE_NAME}:${PG_VERSION}-optimized ${IMAGE_NAME}:${PG_VERSION}-slim

echo "✅ Build concluído!"
echo ""
echo "📦 Imagens criadas:"
echo "   ${IMAGE_NAME}:${PG_VERSION} (versão completa)"
echo "   ${IMAGE_NAME}:${PG_VERSION}-optimized (versão otimizada)"
echo "   ${IMAGE_NAME}:${PG_VERSION}-postgis-pgvector"
echo "   ${IMAGE_NAME}:${PG_VERSION}-slim"
echo ""

# Mostrar tamanhos
echo "📏 Tamanhos das imagens:"
docker images ${IMAGE_NAME} | grep -E "${PG_VERSION}"

echo ""
echo "🚀 Para testar:"
echo "   docker run -d --name test-pg15 -e POSTGRES_PASSWORD=postgres -p 5433:5432 ${IMAGE_NAME}:${PG_VERSION}-optimized"
echo ""
echo "📤 Para publicar:"
echo "   ./scripts/publish-pg15.sh"
