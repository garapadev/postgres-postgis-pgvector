# Use a imagem oficial do PostgreSQL
FROM postgres:16

# Informações do mantenedor
LABEL maintainer="garapadev <garapadev@gmail.com>"
LABEL description="PostgreSQL 16 com PostGIS 3.4 e pgvector 0.7.4"
LABEL version="1.0"

# Variáveis de ambiente para as versões
ENV POSTGIS_VERSION=3.4.2
ENV PGVECTOR_VERSION=0.7.4
ENV GEOS_VERSION=3.12.1
ENV PROJ_VERSION=9.3.1
ENV GDAL_VERSION=3.8.4

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    # Dependências básicas de compilação
    build-essential \
    cmake \
    git \
    wget \
    pkg-config \
    # Dependências do PostgreSQL
    postgresql-server-dev-16 \
    # Dependências do PostGIS
    libxml2-dev \
    libgeos-dev \
    libproj-dev \
    libgdal-dev \
    libjson-c-dev \
    libprotobuf-c-dev \
    protobuf-c-compiler \
    # Dependências adicionais
    libssl-dev \
    libcurl4-openssl-dev \
    libtiff-dev \
    libsqlite3-dev \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Compilar e instalar PostGIS
RUN cd /tmp && \
    wget https://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz && \
    tar -xzf postgis-${POSTGIS_VERSION}.tar.gz && \
    cd postgis-${POSTGIS_VERSION} && \
    ./configure \
        --with-pgconfig=/usr/bin/pg_config \
        --with-geosconfig=/usr/bin/geos-config \
        --with-projdir=/usr \
        --with-gdalconfig=/usr/bin/gdal-config \
        --with-jsondir=/usr \
        --with-protobufdir=/usr && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/postgis-*

# Compilar e instalar pgvector
RUN cd /tmp && \
    git clone --branch v${PGVECTOR_VERSION} https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/pgvector

# Copiar script de inicialização
COPY sql/init.sql /docker-entrypoint-initdb.d/

# Definir variáveis de ambiente padrão
ENV POSTGRES_DB=mydb
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

# Expor a porta padrão do PostgreSQL
EXPOSE 5432

# Comando padrão (herdado da imagem base)
