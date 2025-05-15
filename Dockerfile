FROM golang:1.23 AS builder
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

FROM python:3.9-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential python3-dev libffi-dev libssl-dev \
    chromium libnss3 \
    libatk-bridge2.0-0 libgtk-4-1 libx11-6 libxcomposite1 libxdamage1 libxrandr2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ app/
COPY --from=builder /go/bin/httpx /usr/local/bin/httpx

EXPOSE 5000
ENV FLASK_APP=app
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
