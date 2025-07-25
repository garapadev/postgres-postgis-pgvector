# PostgreSQL + PostGIS + pgvector

🐘 **PostgreSQL** + 🌍 **PostGIS** + 🔍 **pgvector** = Complete database for geospatial and AI applications

## Quick Start

```bash
# PostgreSQL 16 (Latest - Recommended)
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=password garapadev/postgres-postgis-pgvector:latest

# PostgreSQL 16 Optimized (Smaller size - 977MB)
docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=password garapadev/postgres-postgis-pgvector:16-slim
```

## What's Included

- **PostgreSQL 15.13/16.9** - Robust SQL database
- **PostGIS 3.4.2** - Spatial data types and functions
- **pgvector 0.7.4** - Vector similarity search for AI/ML
- **Additional extensions**: fuzzystrmatch, postgis_tiger_geocoder, postgis_topology

## Available Tags

### PostgreSQL 16 (Latest - Recommended)
- `latest` (2.82GB) - Current stable version
- `stable` (2.82GB) - Alias for latest
- `16` (2.82GB) - Full version
- `16-stable` (977MB) - **Production ready optimized**
- `16-optimized` (977MB) - Optimized build
- `16-slim` (977MB) - Compact version

### PostgreSQL 15 (Legacy Support)
- `latest` (2.82GB) - Most recent
- `16-optimized` (808MB) - Optimized build
- `stable` (2.82GB) - Stable version

## Use Cases

### 🤖 AI/ML Applications
```sql
-- Vector similarity search
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    content TEXT,
    embedding VECTOR(1536)
);

SELECT content FROM documents 
ORDER BY embedding <=> '[0.1,0.2,...]'::vector 
LIMIT 5;
```

### 🗺️ Geospatial Applications
```sql
-- Spatial queries
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name TEXT,
    geom GEOMETRY(POINT, 4326)
);

SELECT name FROM locations 
WHERE ST_DWithin(geom::geography, ST_MakePoint(-46.6, -23.5)::geography, 1000);
```

### 🔄 Hybrid Applications
```sql
-- Combine spatial + vector search
SELECT name, 
    ST_Distance(geom::geography, point::geography) as distance,
    1 - (embedding <=> query_vector) as similarity
FROM places 
WHERE ST_DWithin(geom::geography, point::geography, 5000)
ORDER BY embedding <=> query_vector
LIMIT 10;
```

## Docker Compose

```yaml
version: '3.8'
services:
  postgres:
    image: garapadev/postgres-postgis-pgvector:15-stable
    environment:
      POSTGRES_PASSWORD: your_password
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

## Performance Tips

- Use optimized tags (`-optimized`, `-slim`, `-stable`) for production
- Configure `work_mem` for vector operations: `SET work_mem = '256MB'`
- Create appropriate indexes: `CREATE INDEX ON table USING ivfflat (embedding vector_cosine_ops)`

## Testing Extensions

```sql
-- Check versions
SELECT version();
SELECT PostGIS_Full_Version();
\dx

-- Test PostGIS
SELECT ST_AsText(ST_MakePoint(-46.6333, -23.5505));

-- Test pgvector
SELECT '[1,2,3]'::vector <-> '[4,5,6]'::vector;
```

Perfect for:
- RAG applications
- Recommendation systems  
- GIS applications
- Location-based services
- Spatial analysis
- Vector databases
- AI/ML applications

**GitHub**: https://github.com/garapadev/postgres-postgis-pgvector
**Issues**: https://github.com/garapadev/postgres-postgis-pgvector/issues
