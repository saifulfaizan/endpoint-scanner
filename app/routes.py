from flask import render_template, request
from app import app
import subprocess

# Daftar semua flag yang akan dipakai
HTTPX_FLAGS = [
    "-json",
    "-status-code",
    "-content-length",
    "-content-type",
    "-location",
    "-favicon",
    "-hash", "md5",
    "-jarm",
    "-web-server",
    "-title",
    "-tls-probe",
    "-cdn",
    "-waf-detect",
    "-tech-detect",
    "-path", "/admin,/api/v1",
    "-probe",
    "-screenshot",
    "-system-chrome",
    "-srd", "./screenshots",
    "-body-preview",
    "-body-preview-chars", "200",
    "-strip-html",
    "-fep",
    "-dashboard",
    "-asset-name", "MyScan",
    "-dashboard-upload", "output.json"
]

@app.route('/scan', methods=['POST'])
def scan():
    target = request.form['target']
    # Bangun command dengan menyisipkan target di depan flags
    cmd = ["httpx", "-u", target] + HTTPX_FLAGS

    try:
        # Jalankan httpx dengan semua flag
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True
        )
        output = result.stdout
    except subprocess.CalledProcessError as e:
        output = f"Error scanning target: {e.stderr or e}"

    return render_template('index.html', output=output)
