import json
from flask import render_template, request, jsonify, send_file
import subprocess
import io
import csv
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from app import app

BASE_FLAGS = [
    "-json", "-status-code", "-ip", "-location",
    "-web-server", "-title", "-tls-probe", "-cdn",
    "-tech-detect", "-content-length", "-body-preview"
]

@app.route('/', methods=['GET'])
def home():
    return render_template('index.html')

@app.route('/scan', methods=['POST'])
def scan():
    target = request.form['target']
    cmd = ["httpx", "-u", target] + BASE_FLAGS

    try:
        proc = subprocess.run(cmd, capture_output=True, text=True, check=True)
        lines = proc.stdout.splitlines()
        results = [json.loads(line) for line in lines if line.strip()]
        return jsonify(results)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/export/csv', methods=['POST'])
def export_csv():
    data = request.get_json()
    if not data or not isinstance(data, list):
        return "Invalid or empty data", 400

    output = io.StringIO()
    writer = csv.writer(output)

    keys = data[0].keys() if data else []
    writer.writerow(keys)

    for row in data:
        writer.writerow([row.get(k, "") for k in keys])

    output.seek(0)
    return send_file(
        io.BytesIO(output.getvalue().encode('utf-8')),
        mimetype='text/csv',
        as_attachment=True,
        download_name='scan_results.csv'
    )

@app.route('/export/pdf', methods=['POST'])
def export_pdf():
    data = request.get_json()
    if not data or 'target' not in data or 'results' not in data:
        return "Invalid data", 400

    target = data['target'].replace('/', '_').replace(':', '')  # sanitize filename
    results = data['results']

    buffer = io.BytesIO()
    c = canvas.Canvas(buffer, pagesize=letter)
    width, height = letter

    c.setFont("Helvetica", 12)
    y = height - 40
    c.drawString(40, y, f"Scan Results for: {target}")
    y -= 30

    for item in results:
        text = json.dumps(item)
        for line in text.split('\n'):
            if y < 40:
                c.showPage()
                c.setFont("Helvetica", 12)
                y = height - 40
            c.drawString(40, y, line)
            y -= 15

    c.save()
    buffer.seek(0)

    return send_file(
        buffer,
        as_attachment=True,
        download_name=f"{target}.pdf",
        mimetype='application/pdf'
    )
