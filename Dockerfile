# Usar la imagen oficial de PostgreSQL
FROM postgres:latest

# Configuración de variables de entorno
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=admin1234
ENV POSTGRES_DB=sample_db

# Exponer el puerto 5432
EXPOSE 5432
