# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables 
# 1. Prevent Python from writing .pyc files
# 2. Ensure console output is not buffered
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies needed for PostgreSQL (psycopg2)
RUN apt-get update && \
    apt-get install -y libpq-dev gcc && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your local application code into the container
COPY . .

# Expose the port Django's dev server runs on
EXPOSE 8000

# Command to start the server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]