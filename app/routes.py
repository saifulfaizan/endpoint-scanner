from flask import render_template, request, jsonify
from app import app
import subprocess

# Route utama untuk paparkan UI
@app.route('/')
def index():
    return render_template('index.html')

# Route untuk scan dengan input target dan paparkan result
@app.route('/scan', methods=['POST'])
def scan():
    target = request.form['target']  # Dapatkan target dari user input
    try:
        # Jalankan scan menggunakan subprocess (buatkan fail scan untuk `httpx`)
        result = subprocess.run(
            ['httpx', '-target', target, '-json'], 
            capture_output=True, text=True, check=True
        )
        output = result.stdout
        return render_template('index.html', output=output)
    except subprocess.CalledProcessError as e:
        return render_template('index.html', output="Error scanning target.")
