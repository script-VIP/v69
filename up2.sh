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

# Verifikasi versi Node dan npm
print_status "🧪 Memverifikasi Node dan npm..."
echo "✅ Versi Node.js: $(node -v)"
echo "✅ Versi npm: $(npm -v)"

# Install dependensi npm
print_status "📦 Menginstal dependensi npm..."
cd /usr/bin/LTBOTWA && npm install

# Buat systemd service file
print_status "🛠️ Membuat systemd service..."
cat > /etc/systemd/system/ltbotwa.service << EOF
[Unit]
Description=LTBotWA Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/usr/bin/LTBOTWA
ExecStart=/usr/bin/node /usr/bin/LTBOTWA/index.js
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd dan enable service
print_status "🔧 Mengkonfigurasi service..."
systemctl daemon-reload
systemctl enable ltbotwa.service

print_status "🎉 Instalasi selesai!"
print_status "📝 Untuk memulai bot: systemctl start ltbotwa"
print_status "📝 Untuk melihat status: systemctl status ltbotwa"
print_status "📝 Untuk stop bot: systemctl stop ltbotwa"
print_status "📝 Untuk restart bot: systemctl restart ltbotwa"

# Tanya user apakah ingin menjalankan sekarang
read -p "🚀 Jalankan bot sekarang? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    systemctl start ltbotwa.service
    echo "✅ Bot berhasil dijalankan!"
    echo "📊 Status bot: $(systemctl is-active ltbotwa.service)"
fi
