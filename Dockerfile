# Stage 1: Builder
FROM python:3.14-slim AS builder

ENV PIP_NO_CACHE_DIR=1

WORKDIR /build

COPY requirements.txt .

RUN pip install --prefix=/install -r requirements.txt


# Stage 2: Runtime
FROM python:3.14-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY --from=builder /install /usr/local

COPY --chown=1000:33 . .

RUN mkdir -p /app/staticfiles

USER 1000:33

EXPOSE 8000

CMD ["gunicorn", "--workers", "1", "--threads", "2", "--bind", "0.0.0.0:8000", "config.wsgi:application"]
