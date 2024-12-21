# AutoGitScan

**AutoGitScan** adalah alat otomatis yang dirancang untuk dengan efisien menemukan dan mendeteksi direktori `.git` yang terekspos pada subdomain dari domain yang diberikan. Direktori `.git` yang terekspos berpotensi membocorkan kode sumber, file konfigurasi, atau informasi sensitif tentang sebuah proyek. Alat ini khusus dibuat untuk profesional keamanan yang membutuhkan penilaian cepat terhadap postur keamanan sebuah domain dan subdomain-subdomainnya terkait paparan repositori Git.

## Fitur

- **Penemuan Subdomain Otomatis**: Secara otomatis mengambil subdomain menggunakan `crt.sh` dan fallback ke `assetfinder` jika diperlukan.
- **Deteksi Paparan Git**: Memindai subdomain untuk endpoint `.git/HEAD` atau yang serupa untuk memeriksa paparan repositori `.git`.
- **Cepat dan Efisien**: Memanfaatkan alat berkinerja tinggi seperti `httpx` dan `anew` untuk menangani pemindaian dan deduplikasi hasil.
- **Laporan Detail**: Menghasilkan daftar subdomain dan laporan detail terkait hasil deteksi paparan `.git` yang ditemukan.
- **Mudah Digunakan**: Pengaturan minimal dan dapat dijalankan dengan satu perintah.

## Persyaratan

Untuk menggunakan **AutoGitScan**, Anda perlu menginstal beberapa dependensi berikut:

- [curl](https://curl.se/) — untuk melakukan permintaan HTTP.
- [jq](https://stedolan.github.io/jq/) — untuk memproses data JSON.
- [assetfinder](https://github.com/tomnomnom/assetfinder) — untuk menemukan subdomain.
- [httpx](https://github.com/projectdiscovery/httpx) — untuk memeriksa subdomain terkait paparan `.git`.
- [anew](https://github.com/tomnomnom/anew) — untuk deduplikasi hasil output.

## Instalasi

### Mengkloning repositori:

```bash
git clone https://github.com/username/AutoGitScan.git
cd AutoGitScan
```

## Menginstal dependensi
-> Install curl dan jq di sistem Debian/Ubuntu
sudo apt update
sudo apt install curl jq

-> Install assetfinder
go install github.com/tomnomnom/assetfinder@latest

-> Install httpx
go install github.com/projectdiscovery/httpx/cmd/httpx@latest

-> Install anew
go install github.com/tomnomnom/anew@latest


## Penggunaan
./giteksposure.sh <domain>


## Kontribusi
Saya menyambut kontribusi! Jika Anda memiliki perbaikan bug, fitur baru, atau perbaikan lainnya, jangan ragu untuk mengajukan pull request.



