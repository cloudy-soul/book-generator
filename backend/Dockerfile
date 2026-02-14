# Simplified single-stage Dockerfile for backend
FROM python:3.11-slim

WORKDIR /app

# Install OS dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker layer caching
COPY app/requirements-dev.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements-dev.txt uvicorn fastapi

# Copy application code
COPY app/ ./app/
COPY config/ ./app/config/

# Set PYTHONPATH so 'app' module can be found
ENV PYTHONPATH=/app
WORKDIR /app/app

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"

EXPOSE 8000

CMD ["python", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]