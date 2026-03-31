FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies (e.g., if needed by scikit-learn or others)
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc g++ default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy application code and database
COPY . .

# Expose port (Render sets the PORT environment variable natively)
# So we use $PORT dynamically in the command. If PORT is not set, default to 8000.
ENV PORT=8000
EXPOSE $PORT

# Run Uvicorn server
CMD uvicorn app.main:app --host 0.0.0.0 --port $PORT
