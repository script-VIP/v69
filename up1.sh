#!/bin/bash

# Fungsi untuk mencetak output berwarna
print_status() {
    echo -e "\e[1;32m$1\e[0m"
}

print_error() {
    echo -e "\e[1;31m$1\e[0m"
}

# Periksa apakah dijalankan sebagai root
if [ "$EUID" -ne 0 ]; then
    print_error "Script harus dijalankan sebagai root. Gunakan sudo!"
    exit 1
fi

# Buat direktori
print_status "📁 Membuat direktori /usr/bin/LTBOTWA..."
mkdir -p /usr/bin/LTBOTWA

# Download dan ekstrak LTBOTWA
print_status "⬇️ Mengunduh LTBOTWA.zip..."
wget -q https://raw.githubusercontent.com/script-VIP/v69/main/LTbotVPN/LTBOTWA.zip -O /tmp/LTBOTWA.zip

if [ $? -ne 0 ]; then
    print_error "Gagal mengunduh LTBOTWA.zip dari URL pertama"
    exit 1
fi

print_status "📦 Mengekstrak LTBOTWA.zip..."
unzip -q -o /tmp/LTBOTWA.zip -d /tmp/

print_status "🚚 Memindahkan file ke /usr/bin/LTBOTWA..."
mv /tmp/LTBOTWA/* /usr/bin/LTBOTWA/ 2>/dev/null

print_status "🔧 Mengatur izin eksekusi..."
chmod +x /usr/bin/LTBOTWA/* 2>/dev/null
find /usr/bin/LTBOTWA/ -name "*.sh" -exec chmod +x {} \; 2>/dev/null

# Hapus file sementara
print_status "🧹 Membersihkan file sementara..."
rm -rf /tmp/LTBOTWA /tmp/LTBOTWA.zip

# Perbarui sistem
print_status "🔄 Memperbarui dan mengupgrade sistem..."
apt update && apt upgrade -y

# Hapus nodejs dan npm versi lama
print_status "🧼 Menghapus Node.js dan npm versi lama..."
apt purge -y nodejs npm
rm -rf /usr/local/bin/node /usr/local/bin/npm /usr/bin/node /usr/bin/npm /usr/lib/node_modules

# Install curl jika belum ada
print_status "⬇️ Memastikan curl terinstal..."
apt install curl -y

# Install Node.js 20.x LTS dari NodeSource
print_status "📦 Menginstal Node.js versi 20.x LTS..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Install PM2 untuk manajemen proses
print_status "📦 Menginstal PM2 (Process Manager)..."
npm install -g pm2

# Verifikasi versi Node dan npm
print_status "🧪 Memverifikasi Node dan npm..."
echo "✅ Versi Node.js: $(node -v)"
echo "✅ Versi npm: $(npm -v)"

# Install dependensi npm
print_status "📦 Menginstal dependensi npm..."
cd /usr/bin/LTBOTWA && npm install

# Buat startup script untuk PM2
print_status "🔧 Membuat konfigurasi PM2..."
cat > /usr/bin/LTBOTWA/ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: 'ltbotwa',
    script: './index.js',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G',
    env: {
      NODE_ENV: 'production'
    }
  }]
}
EOF

# Setup PM2 untuk start pada boot
print_status "⚙️ Mengatur PM2 untuk start otomatis pada boot..."
pm2 startup
pm2 start /usr/bin/LTBOTWA/ecosystem.config.js
pm2 save

print_status "🎉 Instalasi selesai!"
print_status "📝 Setelah beres memasukan nomor dan pairing code, tekan Ctrl + C"
print_status "🤖 Bot akan tetap berjalan di background dengan PM2"
print_status "📋 Perintah manajemen:"
print_status "   • pm2 status ltbotwa      - Lihat status bot"
print_status "   • pm2 logs ltbotwa        - Lihat logs"
print_status "   • pm2 restart ltbotwa     - Restart bot"
print_status "   • pm2 stop ltbotwa        - Stop bot"

# Jalankan untuk pairing pertama kali
print_status "🚀 Menjalankan aplikasi untuk pairing..."
cd /usr/bin/LTBOTWA && node index.js
