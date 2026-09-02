FROM python:3.14.7-slim
WORKDIR /app

COPY pyproject.toml uv.lock ./
RUN pip install uv && uv sync --locked --no-dev --no-install-project

COPY ./src/docker_practise/pipeline.py pipeline.py

ENTRYPOINT [ "uv", "run", "--no-project", "python", "pipeline.py", "20" ]