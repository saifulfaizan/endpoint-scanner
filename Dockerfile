FROM golang:1.23 AS builder
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

FROM python:3.9-slim

# 1. Instal dependensi system untuk Flask + headless Chrome
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential python3-dev libffi-dev libssl-dev \
      libnss3 chromium \
      libatk-bridge2.0-0 libgtk-4-1 libx11-6 libxcomposite1 libxdamage1 libxrandr2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. Install Flask
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. Copy Flask app
COPY app/ app/

# 4. Copy httpx binary
COPY --from=builder /go/bin/httpx /usr/local/bin/httpx

# 5. Expose port & jalankan Flask
EXPOSE 5000
ENV FLASK_APP=app
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
