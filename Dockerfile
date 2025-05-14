FROM golang:1.23

RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
RUN ln -s /go/bin/httpx /usr/local/bin/httpx

WORKDIR /app

COPY scan_advanced_json.sh /app/scan_advanced_json.sh
COPY targets.txt /app/targets.txt

RUN chmod +x /app/scan_advanced_json.sh

CMD ["/app/scan_advanced_json.sh"]
