@echo off
REM Script para construir e executar a imagem PostgreSQL personalizada no Windows

echo 🐳 Construindo imagem PostgreSQL com PostGIS e pgvector...

REM Construir a imagem
docker build -t garapadev/postgres-postgis-pgvector:latest .

if %errorlevel% neq 0 (
    echo ❌ Erro ao construir a imagem!
    pause
    exit /b %errorlevel%
)

echo ✅ Imagem construída com sucesso!

REM Opção para executar imediatamente
set /p choice="Deseja executar o container agora? (y/N): "
if /i "%choice%"=="y" (
    echo 🚀 Iniciando containers com docker-compose...
    docker-compose up -d
    
    if %errorlevel% neq 0 (
        echo ❌ Erro ao iniciar os containers!
        pause
        exit /b %errorlevel%
    )
    
    echo ⏳ Aguardando o PostgreSQL ficar pronto...
    timeout /t 10 /nobreak > nul
    
    echo ✅ PostgreSQL está rodando!
    echo 📋 Informações de conexão:
    echo    Host: localhost
    echo    Porta: 5432
    echo    Banco: mydb
    echo    Usuário: postgres
    echo    Senha: postgres
    echo.
    echo 🌐 PgAdmin disponível em: http://localhost:8080
    echo    Email: admin@exemplo.com
    echo    Senha: admin
    echo.
    echo 🔗 String de conexão:
    echo    postgresql://postgres:postgres@localhost:5432/mydb
)

pause
