FROM python:3.9-slim

WORKDIR /app

# Install system dependencies with retries to handle hash sum mismatches
RUN for i in 1 2 3; do \
    apt-get update --allow-releaseinfo-change && \
    apt-get install -y --fix-missing \
        gcc \
        postgresql-client \
        curl \
    && break || sleep 5; \
    done && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Run with gunicorn for production-like setup
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "3", "--timeout", "60", "app:app"]