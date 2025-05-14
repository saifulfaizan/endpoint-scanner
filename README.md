# Endpoint Scanner GUI (Flask + Httpx)
![ENDPOINT](https://github.com/user-attachments/assets/15a704cd-2511-4886-9e4a-92d0220bfe07)

https://endpoint-scanner.onrender.com/scan

Web GUI untuk scan endpoint menggunakan ProjectDiscovery Httpx, dibangun dengan Flask dan Docker.  
Siap dijalankan secara lokal maupun deploy di Render.com.

## Fitur
- Input target URL lewat form
- Scan multi‐threaded dengan Httpx
- Output dalam format JSON
- Deployable via Docker & Render.com

---

## Prasyarat
- Docker & Docker Compose (opsional)
- Akun GitHub
- Akun Render.com (untuk deploy online)

---

## Cara Jalankan di Localhost

1. Clone repo dan masuk folder:
   ```bash
   git clone https://github.com/USERNAME/endpoint-scanner-gui.git
   cd endpoint-scanner-gui
   docker build -t endpoint-scanner-gui .
   docker run --rm -p 5000:5000 endpoint-scanner-gui
  ```
 ```
Akses GUI: http://localhost:5000
 
 ```
 ```
## Cara Deploy ke Render.com
Push kode ke GitHub (branch master).

Login ke https://render.com, klik New → Web Service.

Pilih repo endpoint-scanner-gui.

Pilih Docker environment, biarkan Build & Start command kosong.

Deploy dan tunggu build selesai.

Akses URL render yang disediakan, contoh:
(https://endpoint-scanner.onrender.com/scan)
