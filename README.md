# NY Taxi Data Ingestion (Docker Practice)

> Note: This repository is created strictly for learning and educational purposes to practice Docker, Docker Compose, container networking, and basic data engineering workflows.

## Overview

This project is a simple data ingestion pipeline that downloads NYC Yellow Taxi trip data (January 2021) from the DataTalksClub datasets repository and streams it in chunks into a PostgreSQL database running inside a Docker container.

The setup consists of:
- **PostgreSQL**: Stores the ingested taxi trip data.
- **pgAdmin**: Web interface to inspect the PostgreSQL database.
- **Ingestion Script**: Python script using Pandas, SQLAlchemy, and Click to stream and load CSV chunks.
- **uv**: Fast Python package manager used to manage dependencies and run the script in the container.
- **Docker & Docker Compose**: Manages container services, volumes, and networks.

---

## Tech Stack

- Python 3.14
- uv
- PostgreSQL 18
- pgAdmin 4
- Pandas, SQLAlchemy, Psycopg 3, Click, tqdm
- Docker and Docker Compose

---

## Getting Started

### 1. Prerequisites

Make sure Docker and Docker Compose are installed on your machine and the Docker daemon is running.

### 2. Start PostgreSQL and pgAdmin

Start the database and pgAdmin containers in the background:

```bash
docker compose up -d
```

Service details configured in `docker-compose.yaml`:
- **Postgres Database**:
  - Host: `localhost` (from host machine) or `pgdatabase` (from within the Docker network)
  - Port: `5432`
  - User: `root`
  - Password: `root`
  - Database: `ny_taxi`
- **pgAdmin**:
  - URL: `http://localhost:8085`
  - Username: `admin@admin.com`
  - Password: `root`

### 3. Build the Ingestion Docker Image

Build the Docker image containing the ingestion script and its dependencies:

```bash
docker build -t taxi_ingest:v001 .
```

### 4. Run the Ingestion Container

To allow the ingestion container to communicate with the `pgdatabase` container, it must connect to the network created by Docker Compose.

```bash
# check the network link:
docker network ls

# it's pipeline_default (or similar based on directory name, e.g. docker_practise_default)
# now run the script:
docker run -it --rm \
  --network=docker_practise_default \
  taxi_ingest:v001 \
    --pg-user=root \
    --pg-pass=root \
    --pg-host=pgdatabase \
    --pg-port=5432 \
    --pg-db=ny_taxi \
    --target-table=yellow_taxi_trips
```

*(Note: Replace `--network=docker_practise_default` with the actual network name output by `docker network ls` if your directory or project name differs).*

### 5. Verify the Ingested Data

You can verify that data was ingested either via pgAdmin or by connecting directly to the PostgreSQL container using `docker exec`:

```bash
docker exec -it docker_practise-pgdatabase-1 psql -U root -d ny_taxi -c "SELECT count(*) FROM yellow_taxi_trips;"
```

### 6. Clean Up

To stop and remove the containers created by Docker Compose:

```bash
docker compose down
```

To also remove the persisted database volumes:

```bash
docker compose down -v
```
