#!/bin/bash

# Script para fazer build e push da imagem para DockerHub
# Usuário: garapadev

set -e

IMAGE_NAME="garapadev/postgres-postgis-pgvector"

echo "🐳 Construindo imagem PostgreSQL personalizada..."
echo "📦 Nome da imagem: $IMAGE_NAME"

# Construir a imagem principal
echo "🔨 Construindo imagem..."
docker build -t $IMAGE_NAME:latest .

# Construir a versão otimizada
echo "🔨 Construindo versão otimizada..."
docker build -f docker/Dockerfile.optimized -t $IMAGE_NAME:16-optimized .

# Criar tags adicionais
echo "🏷️  Criando tags adicionais..."
docker tag $IMAGE_NAME:latest $IMAGE_NAME:16
docker tag $IMAGE_NAME:latest $IMAGE_NAME:stable
docker tag $IMAGE_NAME:16-optimized $IMAGE_NAME:optimized
docker tag $IMAGE_NAME:16-optimized $IMAGE_NAME:slim

echo "✅ Imagem construída com sucesso!"

# Verificar se o usuário quer fazer push
read -p "Deseja fazer push para o DockerHub? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔐 Fazendo login no DockerHub..."
    docker login
    
    echo "⬆️  Fazendo push das imagens..."
    docker push $IMAGE_NAME:latest
    docker push $IMAGE_NAME:16
    docker push $IMAGE_NAME:stable
    docker push $IMAGE_NAME:16-optimized
    docker push $IMAGE_NAME:optimized
    docker push $IMAGE_NAME:slim
    
    echo "✅ Push concluído com sucesso!"
    echo ""
    echo "🌐 Sua imagem está disponível em:"
    echo "   🐳 Versão completa:"
    echo "      docker pull $IMAGE_NAME:latest"
    echo "      docker pull $IMAGE_NAME:stable"
    echo "   📦 Versão otimizada (recomendada):"
    echo "      docker pull $IMAGE_NAME:16-optimized"
    echo "      docker pull $IMAGE_NAME:optimized"
else
    echo "ℹ️  Push cancelado. Para fazer push manualmente:"
    echo "   docker login"
    echo "   docker push $IMAGE_NAME:latest"
    echo "   docker push $IMAGE_NAME:16-optimized"
fi

echo ""
echo "🎯 Para usar a imagem:"
echo "   docker run -d -p 5432:5432 $IMAGE_NAME:latest"
