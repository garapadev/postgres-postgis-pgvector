@echo off
REM Script para fazer build e push da imagem para DockerHub
REM Usuário: garapadev

set IMAGE_NAME=garapadev/postgres-postgis-pgvector
set PG_VERSION=16
set POSTGIS_VERSION=3.4
set PGVECTOR_VERSION=v0.7.4

echo 🐳 Construindo imagem PostgreSQL personalizada...
echo 📦 Nome da imagem: %IMAGE_NAME%

REM Construir a imagem com múltiplas tags
echo 🔨 Construindo imagem...
docker build -t %IMAGE_NAME%:latest .
if %errorlevel% neq 0 (
    echo ❌ Erro ao construir a imagem!
    pause
    exit /b %errorlevel%
)

docker build -t %IMAGE_NAME%:%PG_VERSION% .
docker build -t %IMAGE_NAME%:%PG_VERSION%-%POSTGIS_VERSION% .
docker build -t %IMAGE_NAME%:%PG_VERSION%-%POSTGIS_VERSION%-%PGVECTOR_VERSION% .

echo ✅ Imagem construída com sucesso!

REM Verificar se o usuário quer fazer push
set /p choice="Deseja fazer push para o DockerHub? (y/N): "
if /i "%choice%"=="y" (
    echo 🔐 Fazendo login no DockerHub...
    docker login
    
    if %errorlevel% neq 0 (
        echo ❌ Erro no login do DockerHub!
        pause
        exit /b %errorlevel%
    )
    
    echo ⬆️  Fazendo push das imagens...
    docker push %IMAGE_NAME%:latest
    docker push %IMAGE_NAME%:%PG_VERSION%
    docker push %IMAGE_NAME%:%PG_VERSION%-%POSTGIS_VERSION%
    docker push %IMAGE_NAME%:%PG_VERSION%-%POSTGIS_VERSION%-%PGVECTOR_VERSION%
    
    if %errorlevel% neq 0 (
        echo ❌ Erro ao fazer push das imagens!
        pause
        exit /b %errorlevel%
    )
    
    echo ✅ Push concluído com sucesso!
    echo.
    echo 🌐 Sua imagem está disponível em:
    echo    docker pull %IMAGE_NAME%:latest
    echo    docker pull %IMAGE_NAME%:%PG_VERSION%
    echo    docker pull %IMAGE_NAME%:%PG_VERSION%-%POSTGIS_VERSION%
    echo    docker pull %IMAGE_NAME%:%PG_VERSION%-%POSTGIS_VERSION%-%PGVECTOR_VERSION%
) else (
    echo ℹ️  Push cancelado. Para fazer push manualmente:
    echo    docker login
    echo    docker push %IMAGE_NAME%:latest
)

echo.
echo 🎯 Para usar a imagem:
echo    docker run -d -p 5432:5432 %IMAGE_NAME%:latest

pause
