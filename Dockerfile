FROM python:3.12.3-bullseye as base

RUN pip install --no-cache-dir --upgrade pip==24.0 \
 && pip install --no-cache-dir setuptools==69.5.1 wheel==0.43.0 \
 && pip install --no-cache-dir poetry==1.8.2


ENV PYTHONBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1 \
    POETRY_CACHE_DIR=/tmp/poetry_cache

WORKDIR /src
COPY poetry.lock pyproject.toml ./

RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry install --no-dev


FROM python:3.12.3-bullseye as prod
ENV VIRTUAL_ENV=/src/.venv \
    PATH="/src/.venv/bin:$PATH"

COPY --from=base ${VIRTUAL_ENV} ${VIRTUAL_ENV}
COPY . .

CMD ["python", "-m", "app"]
