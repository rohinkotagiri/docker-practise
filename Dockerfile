FROM python:3.14.7-slim
WORKDIR /app

COPY pyproject.toml uv.lock ./
RUN pip install uv && uv sync --locked --no-dev --no-install-project

COPY ingest_data.py ingest_data.py

ENTRYPOINT ["uv", "run", "--no-project", "python", "ingest_data.py"]