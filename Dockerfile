# 1) Stage Builder: install httpx Go binary
FROM golang:1.23 AS builder
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# 2) Final Stage: Flask GUI + httpx binary
FROM python:3.9-slim

# Pasang compiler untuk Python extensions (Flask dependency)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential python3-dev libffi-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Flask dari requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy Flask app
COPY app/ app/

# Salin httpx binary dari builder stage
COPY --from=builder /go/bin/httpx /usr/local/bin/httpx

EXPOSE 5000

ENV FLASK_APP=app
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
