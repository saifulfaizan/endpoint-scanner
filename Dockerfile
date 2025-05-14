FROM golang:1.23
FROM python:3.9-slim

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire app
COPY . .

# Expose port untuk Flask
EXPOSE 5000

# Command untuk run Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
RUN ln -s /go/bin/httpx /usr/local/bin/httpx

WORKDIR /app

COPY scan_advanced_json.sh /app/scan_advanced_json.sh
COPY targets.txt /app/targets.txt

RUN chmod +x /app/scan_advanced_json.sh

CMD ["/app/scan_advanced_json.sh"]
