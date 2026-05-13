# --- STAGE 1: Build ---
# We use a standard Python image instead of Ubuntu to get 'pip' easily
FROM python:3.12-slim AS build

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

# Install system dependencies needed to compile psycopg2
RUN apt-get update && \
    apt-get install -y libpq-dev gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Install packages to a specific site-packages directory
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# --- STAGE 2: Runtime ---
# Distroless is tiny and secure because it lacks a shell and package manager
FROM gcr.io/distroless/python3-debian12
WORKDIR /app

# Copy the installed library files from the build stage
COPY --from=build /install /usr/local
# Copy your actual Django project code
COPY . .

# Distroless uses a specific environment; we ensure it's pointed to /app
ENV PYTHONPATH=/usr/local/lib/python3.12/site-packages

EXPOSE 8000

# In Distroless, you must use the 'exec' form (JSON array) for CMD
CMD ["manage.py", "runserver", "0.0.0.0:8000"]