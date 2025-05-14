#!/bin/bash

mkdir -p output
OUTPUT_FILE="output/all_advanced_scan.json"
TMP_DIR="output/tmp"
mkdir -p "$TMP_DIR"

rm -f "$OUTPUT_FILE"
rm -f "$TMP_DIR"/*.json

echo "[*] Starting advanced multi-threaded scan..."

cat targets.txt | while read -r url; do
    domain=$(echo $url | sed 's~https\?://~~' | sed 's~/.*~~')
    (
        echo "[*] Scanning $url"
        httpx -u "$url" \
            -json \
            -title \
            -web-server \
            -tls-probe \
            -cdn \
            -waf-detect \
            -location \
            -ip \
            -status-code \
            -tech-detect \
            -o "$TMP_DIR/${domain}.json"
        echo "[+] Done: $url"
    ) &
done

wait

echo "[*] Merging all JSON results to $OUTPUT_FILE"

echo "[" > "$OUTPUT_FILE"
find "$TMP_DIR" -type f -name "*.json" | while read -r file; do
    cat "$file"
    echo ","
done | sed '$ s/,$//' >> "$OUTPUT_FILE"
echo "]" >> "$OUTPUT_FILE"

echo "[+] All done. Output: $OUTPUT_FILE"