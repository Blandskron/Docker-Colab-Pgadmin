# Proyecto de Base de Datos con PostgreSQL y Túnel Público

Este proyecto configura un entorno de base de datos PostgreSQL en un contenedor Docker y expone la base de datos a través de un túnel público utilizando `localtunnel`. Esto permite acceder a la base de datos desde ubicaciones remotas, como Google Colab, para ejecutar consultas, rellenar datos y realizar visualizaciones.

## Archivos del Proyecto

### 1. `docker-compose.yml`

Este archivo configura los servicios de Docker para ejecutar una base de datos PostgreSQL y un túnel público a través de `localtunnel`.

#### Componentes

- **PostgreSQL Service**:
  - **Imagen**: `postgres:latest`
  - **Contenedor**: `postgres_container`
  - **Variables de entorno**:
    - `POSTGRES_USER`: Configura el nombre de usuario de PostgreSQL.
    - `POSTGRES_PASSWORD`: Configura la contraseña de PostgreSQL.
    - `POSTGRES_DB`: Configura el nombre de la base de datos.
  - **Puertos**:
    - El puerto `5432` de PostgreSQL se expone localmente como `5433`.
  - **Redes**:
    - Se conecta a la red `pg_network`.

- **Localtunnel Service**:
  - **Imagen**: `node:alpine`
  - **Contenedor**: `localtunnel_service`
  - **Directorio de trabajo**: `/app`
  - **Comando**: Instala `localtunnel` y configura un túnel para el puerto `5433`.
  - **Redes**:
    - Se conecta a la red `pg_network`.

- **Red**: `pg_network` es una red de tipo `bridge` que conecta los dos servicios.

#### Ejecución de `docker-compose.yml`

Para levantar los servicios, usa:
```bash
docker-compose up -d
```
Esto iniciará ambos contenedores y permitirá el acceso remoto a la base de datos PostgreSQL a través de un túnel público.

### 2. `Dockerfile`

Este archivo es una configuración base para el contenedor de PostgreSQL.

#### Componentes

- **Imagen base**: `postgres:latest`
- **Variables de entorno**:
  - Configura el usuario, contraseña y base de datos para PostgreSQL, replicando las variables en `docker-compose.yml`.
- **Exposición de puerto**:
  - Expone el puerto `5432`, permitiendo la conexión a PostgreSQL desde otros servicios en la misma red Docker.

#### Construcción y Uso

Para construir esta imagen personalizada, puedes usar:
```bash
docker build -t custom_postgres .
```

### 3. `Conectar_con_DB.ipynb`

Este archivo es un Notebook de Google Colab o Jupyter que establece una conexión con la base de datos PostgreSQL a través de la URL pública generada por `localtunnel`. El propósito es ejecutar consultas y visualizar datos directamente desde un entorno remoto.

#### Componentes del Notebook

1. **Conexión a la Base de Datos**: Utiliza la URL pública y el puerto generado por `localtunnel` para conectarse a la base de datos en el contenedor PostgreSQL.
2. **Inserción de Datos**: El Notebook contiene scripts para crear tablas y llenar datos de muestra.
3. **Consultas y Visualización**: Incluye ejemplos para extraer datos de la base de datos y graficarlos usando `seaborn` y `matplotlib`.

### Configuración Final del Proyecto

- **Obtener URL de Conexión**:
  - Revisa los registros del contenedor `localtunnel_service` para obtener la URL pública.
  ```bash
  docker logs localtunnel_service
  ```
- **Acceso Remoto**:
  - Usa la URL y el puerto de `localtunnel` en el Notebook para establecer la conexión a PostgreSQL y realizar consultas de manera remota.

## Ejemplo de Conexión en el Notebook

```python
import psycopg2
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Conexión a la base de datos usando la URL de localtunnel
conn = psycopg2.connect(
    host='your_public_url.loca.lt',  # Reemplaza con tu URL
    port='5434',                     # Reemplaza con el puerto que se haya asignado
    database='sample_db',
    user='postgres',
    password='admin1234'
)

# Crear un DataFrame a partir de una consulta
query = "SELECT * FROM mi_tabla"
df = pd.read_sql(query, conn)

# Graficar los datos usando seaborn
sns.set(style="whitegrid")
plt.figure(figsize=(10, 6))
sns.barplot(data=df, x="nombre", y="edad", palette="viridis")
plt.xticks(rotation=45)
plt.title("Edades por Nombre")
plt.show()
```

Este código permite realizar análisis y visualización de datos de manera remota, aprovechando la potencia de Google Colab y la conectividad del túnel.
