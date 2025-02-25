FROM python:3.13-alpine3.21
# Image base https://hub.docker.com/_/python

# About image
LABEL maintainer="Aécio Pires" \
      date_create="02/25/2025" \
      version="1.0.0" \
      description="My health check system" \
      license="GPL-3.0"

# Work dir
WORKDIR /app

# Copy files to image
COPY app/main.py /app
COPY app/.env /app
COPY app/requirements.txt /app/requirements.txt

# Install dependencies
RUN pip install -r requirements.txt

# Start program during container creation
CMD ["python", "main.py"]
