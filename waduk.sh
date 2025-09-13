#!/bin/bash
# Create anyewhere : 2015
# Bringas Tunnel | Bringas Family
# Lunatic Tunneling ( LT )
# Autheeer :  Lunatic Tunneling
# Bandung Barat | jawa Barat
# Who i am : from Indonesia
# Recode ? Jangan Hilangkan Watermark tod bodoh
export TERM=xterm
export DEBIAN_FRONTEND=noninteractive
dpkg-reconfigure debconf -f noninteractive 2>/dev/null

rm -f $0

apt update -y && apt upgrade -y && apt install git -y && apt install at -y
apt install curl -y && apt install wget -y && apt install jq -y
apt install lolcat -y && apt install gem -y && gem install lolcat -y
apt install dos2unix -y
apt install python -y && apt install python3 -y
apt install socat
IPVPS=$(curl -sS ipv4.icanhazip.com)
export IP=$( curl -sS icanhazip.com )

# GIT REPO
LUNAREP="https://raw.githubusercontent.com/script-VIP/v69/main/"

# // TELEGRAM NOTIFIKASI
BOTKEY="7783206606:AAF1EQYzyTqkiE8gY_VqUzkRDHhe1AsjGwk"
AIDI="6198984094"

echo "BOTKEY" > /etc/lunatic/bot/notif/key
echo "AIDI" >> /etc/lunatic/bot/notif/id

function check_os_version() {
    local os_id os_version

    os_id=$(grep -w ID /etc/os-release | cut -d= -f2 | tr -d '"')
    os_version=$(grep -w VERSION_ID /etc/os-release | cut -d= -f2 | tr -d '"')

    case "$os_id" in
        ubuntu)
            case "$os_version" in
                20.04|22.04|22.10|23.04|24.04|24.10|25.04|25.10)
                    echo -e "${OK} Your OS is supported: Ubuntu $os_version"
                    ;;
                *)
                    echo -e "${ERROR} Ubuntu version $os_version is not supported."
                    exit 1
                    ;;
            esac
            ;;
        debian)
            case "$os_version" in
                10|11|12|13)
                    echo -e "${OK} Your OS is supported: Debian $os_version"
                    ;;
                *)
                    echo -e "${ERROR} Debian version $os_version is not supported."
                    exit 1
                    ;;
            esac
            ;;
        *)
            echo -e "${ERROR} Your OS ($os_id $os_version) is not supported."
            exit 1
            ;;
    esac
}

if [[ $( uname -m ) == "x86_64" ]]; then
    echo -e "${OK} Your Architecture Is Supported ( ${green}$( uname -m )${NC} )"
else
    echo -e "${ERROR} Your Architecture Is Not Supported ( ${YELLOW}$( uname -m )${NC} )"
    exit 1
fi

# Cek versi OS
check_os_version


if [ "${EUID}" -ne 0 ]; then
   echo "You need to run this script as root"
   exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
   echo "OpenVZ is not supported"
   exit 1
fi

# =========================[ WARNA ANSI ]=========================
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
NC="\e[0m" # No Color
OK="[${GREEN}OK${NC}]"
ERROR="[${RED}ERROR${NC}]"

BIRU="\033[38;2;0;191;255m"
HIJAU="\033[38;2;173;255;47m"
PUTIH="\033[38;2;255;255;255m"
CYANS="\033[38;2;35;235;195m"
GOLD="\033[38;2;255;215;0m"
RESET="\033[0m"
# =========================[ FUNGSI UTILITAS ]=========================

print_error() {
    echo -e "${ERROR} ${RED}$1${NC}"
}

print_info() {
    echo -e "${YELLOW}[*] $1${NC}"
}

# Menampilkan pesan OK
print_ok() {
    echo -e "${OK} ${BLUE}$1${NC}"
}


# Menampilkan proses instalasi
print_install() {
    echo -e "${BIRU}──────────────────────────────────────${NC}"
    echo -e "${GOLD}# $1${NC}"
    echo -e "${BIRU}──────────────────────────────────────${NC}"
    sleep 1
}


# Menampilkan pesan sukses jika exit code 0
print_success() {
    if [[ $? -eq 0 ]]; then
    echo -e "${BIRU}──────────────────────────────────────${NC}"
    echo -e "${HIJAU}# $1 Sukses!${NC}"
    echo -e "${BIRU}──────────────────────────────────────${NC}"
        sleep 1
    fi
}

# Cek apakah user adalah root
is_root() {
    if [[ $EUID -eq 0 ]]; then
        print_ok "User root terdeteksi. Memulai proses instalasi..."
    else
        print_error "User saat ini bukan root. Silakan gunakan sudo atau login sebagai root!"
        exit 1
    fi
}

# =========================[ PERSIAPAN SISTEM XRAY ]=========================

print_install "Membuat direktori dan file konfigurasi Xray"

mkdir -p /etc/xray
curl -s ifconfig.me > /etc/xray/ipvps
touch /etc/xray/domain

mkdir -p /var/log/xray
chown www-data:www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/auth.log
mkdir -p /var/lib/luna >/dev/null 2>&1

print_success "Direktori dan file konfigurasi Xray berhasil dibuat"

# =========================[ CEK PENGGUNAAN RAM ]=========================

print_install "Menghitung penggunaan RAM"

mem_used=0
mem_total=0

while IFS=":" read -r key value; do
    value_kb=${value//[^0-9]/}  # Hanya ambil angka
    case $key in
        "MemTotal") 
            mem_total=$value_kb
            mem_used=$value_kb
            ;;
        "Shmem") 
            mem_used=$((mem_used + value_kb))
            ;;
        "MemFree" | "Buffers" | "Cached" | "SReclaimable")
            mem_used=$((mem_used - value_kb))
            ;;
    esac
done < /proc/meminfo

Ram_Usage=$((mem_used / 1024))  # dalam MB
Ram_Total=$((mem_total / 1024)) # dalam MB

print_ok "RAM Digunakan : ${Ram_Usage} MB / ${Ram_Total} MB"

# =========================[ INFO SISTEM ]=========================

export tanggal=$(date +"%d-%m-%Y - %X")
export OS_Name=$(grep -w PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
export Kernel=$(uname -r)
export Arch=$(uname -m)
export IP=$(curl -s https://ipinfo.io/ip)

print_ok "Tanggal     : $tanggal"
print_ok "OS          : $OS_Name"
print_ok "Kernel      : $Kernel"
print_ok "Arsitektur  : $Arch"
print_ok "IP Publik   : $IP"

# =========================[ FUNGSI SETUP UTAMA ]=========================

PROXY_SETUP() {
    # Set zona waktu ke Asia/Jakarta
    timedatectl set-timezone Asia/Jakarta
    print_success "Timezone diset ke Asia/Jakarta"

    # Otomatis simpan aturan iptables
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

    # Ambil OS info
    OS_ID=$(grep -w ^ID /etc/os-release | cut -d= -f2 | tr -d '"')
    OS_NAME=$(grep -w PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

    print_success "Direktori Xray berhasil disiapkan"

# ubuntu
    # Instalasi tergantung distribusi OS
    if [[ "$OS_ID" == "ubuntu" ]]; then
        print_info "Deteksi OS: $OS_NAME"
        print_info "Menyiapkan dependensi untuk Ubuntu..."

        apt-get install haproxy -y
        apt-get install nginx -y
        systemctl stop haproxy
        systemctl stop nginx

        print_success "HAProxy untuk Ubuntu ${OS_ID} telah terinstal"

## debian
    elif [[ "$OS_ID" == "debian" ]]; then
        print_info "Deteksi OS: $OS_NAME"
        print_info "Menyiapkan dependensi untuk Debian..."

        apt install haproxy -y
        apt install nginx -y        
        systemctl stop haproxy
        systemctl stop nginx
        
        print_success "HAProxy untuk Debian ${OS_ID} telah terinstal"

    else
        print_error "OS Tidak Didukung: $OS_NAME"
        exit 1
    fi
}

TOOLS_SETUP() {
    clear
    print_install "Menginstal paket dasar dan dependensi"

    # Paket utama
    apt update -y
    apt upgrade -y
    apt dist-upgrade -y

    # Paket dasar
    apt install -y \
        zip pwgen openssl netcat cron bash-completion figlet sudo \
        zip unzip p7zip-full screen git cmake make build-essential \
        gnupg gnupg2 gnupg1 apt-transport-https lsb-release jq htop lsof tar \
        dnsutils python3-pip python ruby ca-certificates bsd-mailx msmtp-mta \
        ntpdate chrony chronyd ntpdate easy-rsa openvpn \
        net-tools rsyslog dos2unix sed xz-utils libc6 util-linux shc gcc g++ \
        libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev \
        libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison \
        libnss3-tools libevent-dev zlib1g-dev libssl-dev libsqlite3-dev \
        libxml-parser-perl dirmngr

    # Bersih-bersih dan setting iptables-persistent
    sudo apt-get clean all
    sudo apt-get autoremove -y
    sudo apt-get remove --purge -y exim4 ufw firewalld
    sudo apt-get install -y debconf-utils

    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
    apt install -y iptables iptables-persistent netfilter-persistent
    
    apt install rsyslog -y
    # Sinkronisasi waktu
    systemctl enable chronyd chrony
    systemctl restart chronyd chrony
    systemctl restart syslog
    ntpdate pool.ntp.org
    chronyc sourcestats -v
    chronyc tracking -v

    print_success "Semua paket dasar berhasil diinstal dan dikonfigurasi"
}


DOMENS_SETUP() {
  clear
  echo "==========================="
  echo "      DOMAIN MANAGER"
  echo "==========================="
  echo -e "\e[97;1m1. Domain custom \e[92;1m(RECOMMENDED)\e[0m"
  echo -e "\e[97;1m2. Domain random"
  echo "==========================="
  read -p "Pilih menu [1-2]: " pilih

  # Pastikan dependency
  command -v jq >/dev/null 2>&1 || { echo "jq belum terpasang. Install dulu: apt-get install -y jq"; return 1; }

  # === CREDENTIAL CLOUDFLARE (dipakai hanya untuk opsi 2) ===
  CF_ID="imanfals51@gmail.com"
  CF_KEY="0f9ed4286475de79bae2b91e9af4f8af9fed9"

  # === DOMAIN UTAMA (untuk opsi 2 / random) ===
  DOMAIN="rasapremium.my.id"
  IPVPS=$(curl -s ipv4.icanhazip.com)

  if [[ "$pilih" == "1" ]]; then
    # ====== OPSI 1: DOMAIN CUSTOM (tanpa Cloudflare API) ======
    read -p "INPUT YOUR DOMAIN: " customhost
    if [[ -z "${customhost}" ]]; then
      echo "Hostname tidak boleh kosong."
      return 1
    fi
    # === Simpan Hasil Domain ke File (APPEND) ===
    echo "$customhost" >> /etc/xray/domain
    echo "$customhost" >> ~/domain # /root/domain
    echo "✅ Domain custom tersimpan: $customhost"
    return 0

# // menu 2
  elif [[ "$pilih" == "2" ]]; then
    # ====== OPSI 2: DOMAIN RANDOM (pakai Cloudflare API) ======
    SUBDOMAIN=$(tr -dc 'a-z0-9' </dev/urandom | head -c 5)
    RECORD="$SUBDOMAIN.$DOMAIN"

    # === Get Zone ID dari Cloudflare ===
    ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN" \
         -H "X-Auth-Email: $CF_ID" \
         -H "X-Auth-Key: $CF_KEY" \
         -H "Content-Type: application/json" | jq -r .result[0].id)

    if [[ -z "$ZONE_ID" || "$ZONE_ID" == "null" ]]; then
      echo "Gagal mendapatkan Zone ID untuk $DOMAIN. Cek CF_ID/CF_KEY/DOMAIN."
      return 1
    fi

    # === Cek apakah record sudah ada ===
    RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&name=$RECORD" \
         -H "X-Auth-Email: $CF_ID" \
         -H "X-Auth-Key: $CF_KEY" \
         -H "Content-Type: application/json" | jq -r .result[0].id)

    # === Tambah / Update Record ===
    if [[ "$RECORD_ID" == "null" || -z "$RECORD_ID" ]]; then
      echo "➕ Menambahkan record baru: $RECORD -> $IPVPS"
      curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
           -H "X-Auth-Email: $CF_ID" \
           -H "X-Auth-Key: $CF_KEY" \
           -H "Content-Type: application/json" \
           --data "{\"type\":\"A\",\"name\":\"$RECORD\",\"content\":\"$IPVPS\",\"ttl\":120,\"proxied\":false}" > /dev/null
    else
      echo "🔄 Mengupdate record lama: $RECORD -> $IPVPS"
      curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
           -H "X-Auth-Email: $CF_ID" \
           -H "X-Auth-Key: $CF_KEY" \
           -H "Content-Type: application/json" \
           --data "{\"type\":\"A\",\"name\":\"$RECORD\",\"content\":\"$IPVPS\",\"ttl\":120,\"proxied\":false}" > /dev/null
    fi

    # === Simpan Hasil Domain ke File (APPEND) ===
    echo "$RECORD" >> /etc/xray/domain
    echo "$RECORD" >> ~/domain # /root/domain

    echo "✅ Subdomain aktif: $RECORD"
    return 0
  else
    echo "Pilihan tidak valid!"
    return 1
  fi
}

SSL_SETUP() {
    clear
    print_install "Memasang SSL Certificate pada domain"

    # Cek domain
    if [[ ! -f /etc/xray/domain ]]; then
        print_error "File /etc/xray/domain tidak ditemukan!"
        return 1
    fi

    domain=$(cat /etc/xray/domain)

    # Hentikan service yang menggunakan port 80
    webserver_port=$(lsof -i:80 | awk 'NR==2 {print $1}')
    if [[ -n "$webserver_port" ]]; then
        print_info "Menghentikan service $webserver_port yang menggunakan port 80..."
        systemctl stop "$webserver_port"
    fi

    systemctl stop nginx >/dev/null 2>&1

    # Hapus sertifikat lama
    rm -f /etc/xray/xray.key /etc/xray/xray.crt
    rm -rf /root/.acme.sh
    mkdir -p /root/.acme.sh

    # Download ACME.sh
    curl -s https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh

    # Upgrade dan konfigurasi ACME
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt

    # Proses issue SSL
    /root/.acme.sh/acme.sh --issue -d "$domain" --standalone -k ec-256
    if [[ $? -ne 0 ]]; then
        print_error "Gagal mendapatkan sertifikat SSL dari Let's Encrypt"
        return 1
    fi

    # Pasang sertifikat ke direktori Xray
    ~/.acme.sh/acme.sh --installcert -d "$domain" \
        --fullchainpath /etc/xray/xray.crt \
        --keypath /etc/xray/xray.key \
        --ecc

    chmod 600 /etc/xray/xray.key /etc/xray/xray.crt

    print_success "Sertifikat SSL berhasil dipasang untuk domain: $domain"
}


FODER_SETUP() {
local main_dirs=(
        "/etc/xray" "/var/lib/luna" "/etc/lunatic" "/etc/limit"
        "/etc/vmess" "/etc/vless" "/etc/trojan" "/etc/ssh"
    )
    
    local lunatic_subdirs=("vmess" "vless" "trojan" "ssh" "bot" "sstp" "pptp" "l2tp" "wireguard")
    local lunatic_types=("usage" "ip" "detail")

    local protocols=("vmess" "vless" "trojan" "ssh" "sstp" "pptp" "l2tp" "wireguard")

    for dir in "${main_dirs[@]}"; do
        mkdir -p "$dir"
    done

    for service in "${lunatic_subdirs[@]}"; do
        for type in "${lunatic_types[@]}"; do
            mkdir -p "/etc/lunatic/$service/$type"
        done
    done

    for protocol in "${protocols[@]}"; do
        mkdir -p "/etc/limit/$protocol"
    done

    local databases=(
        "/etc/lunatic/vmess/.vmess.db"
        "/etc/lunatic/vless/.vless.db"
        "/etc/lunatic/trojan/.trojan.db"
        "/etc/lunatic/ssh/.ssh.db"
        "/etc/lunatic/bot/.bot.db"
        "/etc/lunatic/trojan/.sstp.db"
        "/etc/lunatic/ssh/.pptp.db"
        "/etc/lunatic/bot/.l2tp.db" 
        "/etc/lunatic/bot/.wireguard.db"         
    )

    for db in "${databases[@]}"; do
        touch "$db"
        echo "& plugin Account" >> "$db"
    done

    touch /etc/.{ssh,vmess,vless,trojan,sstp,pptp,l2tp,wireguard}.db
    echo "IP=" > /var/lib/luna/ipvps.conf
}

XRAY_SETUP() {
    clear
    print_install "Menginstall Xray Core Versi 4,22,24"

    # Buat directory untuk socket domain jika belum ada
    local domainSock_dir="/run/xray"
    [[ ! -d $domainSock_dir ]] && mkdir -p "$domainSock_dir"
    chown www-data:www-data "$domainSock_dir"

    # Install Xray Core
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 24.10.31

    # Konfigurasi file dan service custom
    wget -q -O /etc/xray/config.json "${LUNAREP}configure/config.json"
    wget -q -O /etc/systemd/system/runn.service "${LUNAREP}configure/runn.service"

    # Validasi domain
    if [[ ! -f /etc/xray/domain ]]; then
        print_error "File domain tidak ditemukan di /etc/xray/domain"
        return 1
    fi
    local domain=$(cat /etc/xray/domain)
    local IPVS=$(cat /etc/xray/ipvps)

    print_success "Xray Core Versi $latest_version berhasil dipasang"
    clear

    # Tambahkan info kota dan ISP
    curl -s ipinfo.io/city >> /etc/xray/city
    curl -s ipinfo.io/org | cut -d " " -f 2- >> /etc/xray/isp

    print_install "Memasang Konfigurasi Paket Tambahan"

    # Haproxy dan Nginx Config
    wget -q -O /etc/haproxy/haproxy.cfg "${LUNAREP}configure/haproxy.cfg"
    wget -q -O /etc/nginx/conf.d/xray.conf "${LUNAREP}configure/xray.conf"
    curl -s "${LUNAREP}configure/nginx.conf" > /etc/nginx/nginx.conf

    # Ganti placeholder domain
    sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
    sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf

    # Gabungkan sertifikat ke haproxy
    cat /etc/xray/xray.crt /etc/xray/xray.key > /etc/haproxy/hap.pem

    # Tambahkan service unit untuk xray
    cat > /etc/systemd/system/xray.service <<EOF
[Unit]
Description=Xray Service
Documentation=https://github.com/XTLS/Xray-core
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target
EOF

    chmod +x /etc/systemd/system/runn.service
    rm -rf /etc/systemd/system/xray.service.d

    print_success "Konfigurasi Xray dan Service berhasil"
}

PW_DEFAULT() {
    clear
    print_install "Mengatur Password Policy dan Konfigurasi SSH"

    # Download file konfigurasi password PAM
    local password_url="https://raw.githubusercontent.com/script-VIP/v69/main/configure/password"
    wget -q -O /etc/pam.d/common-password "$password_url"
    chmod 644 /etc/pam.d/common-password

    # Konfigurasi layout keyboard non-interaktif
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration

    debconf-set-selections <<EOF
keyboard-configuration keyboard-configuration/layout select English
keyboard-configuration keyboard-configuration/layoutcode string us
keyboard-configuration keyboard-configuration/model select Generic 105-key (Intl) PC
keyboard-configuration keyboard-configuration/modelcode string pc105
keyboard-configuration keyboard-configuration/variant select English
keyboard-configuration keyboard-configuration/variantcode string
keyboard-configuration keyboard-configuration/store_defaults_in_debconf_db boolean true
keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout
keyboard-configuration keyboard-configuration/compose select No compose key
keyboard-configuration keyboard-configuration/switch select No temporary switch
keyboard-configuration keyboard-configuration/toggle select No toggling
keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false
keyboard-configuration keyboard-configuration/unsupported_config_layout boolean true
keyboard-configuration keyboard-configuration/unsupported_config_options boolean true
keyboard-configuration keyboard-configuration/unsupported_layout boolean true
keyboard-configuration keyboard-configuration/unsupported_options boolean true
EOF

    # Konfigurasi systemd rc-local agar bisa eksekusi skrip tambahan saat boot
    cat > /etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local compatibility
ConditionPathExists=/etc/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF

    # Isi default dari rc.local
    cat > /etc/rc.local <<EOF
#!/bin/bash
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
exit 0
EOF

    chmod +x /etc/rc.local
    systemctl enable rc-local.service
    systemctl start rc-local.service

    # Nonaktifkan IPv6 secara langsung juga saat ini
    echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6

    # Set zona waktu Jakarta
    ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

    # Nonaktifkan AcceptEnv agar tidak override env SSH
    sed -i 's/^AcceptEnv/#AcceptEnv/' /etc/ssh/sshd_config

    # Restart SSH jika dibutuhkan
    systemctl restart ssh

    print_success "Konfigurasi SSH & Password Policy"
}


LIMIT_HANDLER() {
    clear
    print_install "Memasang Service Limit Quota"

    # Download dan jalankan install.sh untuk setup awal
    wget https://raw.githubusercontent.com/script-VIP/v69/main/LimitHandler/install.sh && chmod +x install.sh && ./install.sh

    # Download file limit-ip ke /usr/bin/
    cd
    wget -q -O /usr/bin/limit-ip "${LUNAREP}LimitHandler/limit-ip"
    chmod +x /usr/bin/limit-ip
    sed -i 's/\r//' /usr/bin/limit-ip

    # Buat dan aktifkan systemd service untuk VMess IP limit
    cat >/etc/systemd/system/vmip.service << EOF
[Unit]
Description=VMess IP Limiter
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vmip
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now vmip

    # Buat dan aktifkan service untuk VLESS IP limit
    cat >/etc/systemd/system/vlip.service << EOF
[Unit]
Description=VLESS IP Limiter
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip vlip
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now vlip

    # Buat dan aktifkan service untuk Trojan IP limit
    cat >/etc/systemd/system/trip.service << EOF
[Unit]
Description=Trojan IP Limiter
After=network.target

[Service]
WorkingDirectory=/root
ExecStart=/usr/bin/limit-ip trip
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now trip

    # Pasang dan beri izin eksekusi untuk udp-mini
    mkdir -p /usr/local/lunatic
    wget -q -O /usr/local/lunatic/udp-mini "${LUNAREP}configure/udp-mini"
    chmod +x /usr/local/lunatic/udp-mini

    # Download dan pasang 3 service UDP Mini berbeda (multi-instance)
    for i in 1 2 3; do
        wget -q -O /etc/systemd/system/udp-mini-$i.service "${LUNAREP}configure/udp-mini-$i.service"
        systemctl daemon-reload
        systemctl enable --now udp-mini-$i
    done

    print_success "File Quota Autokill & UDP Services berhasil diinstal."
}

SLOWDNS_SETUP(){
clear
print_install "Memasang modul SlowDNS Server"
wget -q -O /tmp/nameserver "${LUNAREP}configure/nameserver" >/dev/null 2>&1
chmod +x /tmp/nameserver
bash /tmp/nameserver | tee /root/install.log
print_success "SlowDNS"
}


# ========================================
# Fungsi: Install dan Konfigurasi SSHD
# ========================================
SSHD_SETUP(){
    clear
    print_install "Memasang SSHD"

    # Download konfigurasi SSH dari repo
    wget -q -O /etc/ssh/sshd_config "${LUNAREP}configure/sshd" >/dev/null 2>&1

    # Atur permission file konfigurasi
    chmod 700 /etc/ssh/sshd_config

    # Restart layanan SSH
    /etc/init.d/ssh restart
    systemctl restart ssh

    print_success "SSHD"
}

# ========================================
# Fungsi: Install dan Konfigurasi Dropbear
# ========================================
DROPBEAR_SETUP(){
    clear
    print_install "Menginstall Dropbear"

    # Install Dropbear
    apt install dropbear -y > /dev/null 2>&1
    
    # Install dropbear Versi 2019.78
    wget ${LUNAREP}install-dropbear.sh && chmod +x install-dropbear.sh && ./install-dropbear.sh
    # Download konfigurasi dropbear
    wget -q -O /etc/default/dropbear "${LUNAREP}configure/dropbear.conf"

    # Pastikan file bisa dieksekusi
    chmod +x /etc/default/dropbear
    chmod 600 /etc/default/dropbear
    
    chmod 755 /usr/sbin/dropbear
    # Restart Dropbear dan tampilkan status
    /etc/init.d/dropbear restart

    print_success "Dropbear"
}

# ========================================
# Fungsi: Install dan Konfigurasi Vnstat
# ========================================
vnSTATS_SETUP(){
    clear
    print_install "Menginstall Vnstat"

    # Install vnstat dari repository
    apt -y install vnstat > /dev/null 2>&1
    /etc/init.d/vnstat restart

    # Install dependency untuk compile manual
    apt -y install libsqlite3-dev > /dev/null 2>&1

    # Download dan ekstrak source vnstat versi terbaru
    wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
    tar zxvf vnstat-2.6.tar.gz

    # Compile dan install vnstat
    cd vnstat-2.6
    ./configure --prefix=/usr --sysconfdir=/etc && make && make install
    cd

    # Inisialisasi database vnstat untuk interface tertentu
    vnstat -u -i $NET

    # Sesuaikan konfigurasi interface
    sed -i "s/Interface \"eth0\"/Interface \"$NET\"/g" /etc/vnstat.conf

    # Set hak akses direktori data vnstat
    chown vnstat:vnstat /var/lib/vnstat -R

    # Aktifkan dan restart vnstat
    systemctl enable vnstat
    /etc/init.d/vnstat restart
    /etc/init.d/vnstat status

    # Bersihkan file installer
    rm -f /root/vnstat-2.6.tar.gz
    rm -rf /root/vnstat-2.6

    print_success "Vnstat"
}
OPVPN_SETUP() {
    clear
    print_install "Menginstall OpenVPN"

    # Unduh installer OpenVPN dari repo Anda, beri izin eksekusi, lalu jalankan
    wget ${LUNAREP}configure/openvpn
    chmod +x openvpn
    ./openvpn

    # Restart layanan OpenVPN
    /etc/init.d/openvpn restart

    print_success "OpenVPN"
}


RCLONE_SETUP() {
    clear
    print_install "Memasang Backup Server"

    # Instalasi rclone
    apt install rclone -y
    printf "q\n" | rclone config

    # Unduh konfigurasi rclone
    wget -O /root/.config/rclone/rclone.conf "${LUNAREP}configure/rclone.conf"

    # Clone dan install wondershaper untuk manajemen bandwidth
    cd /bin
    git clone https://github.com/LunaticTunnel/wondershaper.git
    cd wondershaper
    sudo make install
    cd ~
    rm -rf wondershaper

    # Buat file dummy untuk backup (kalau belum ada)
    echo > /home/files

    # Install tool pengirim email
    apt install msmtp-mta ca-certificates bsd-mailx -y

    # Konfigurasi msmtp (pengiriman email backup via Gmail SMTP)
    cat <<EOF > /etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
account default
host smtp.gmail.com
port 587
auth on
user oceantestdigital@gmail.com
from oceantestdigital@gmail.com
password jokerman77
logfile ~/.msmtp.log
EOF

    # Ubah permission agar bisa diakses oleh webserver jika perlu
    chown -R www-data:www-data /etc/msmtprc

    # Download file ipserver dan eksekusi
    wget -q -O /etc/ipserver "${LUNAREP}configure/ipserver" && bash /etc/ipserver

    print_success "Backup Server"
}


# Fungsi: Menginstall swap 1GB dan alat monitoring gotop
SWAPRAM_SETUP(){
    clear
    print_install "Memasang Swap 2 GB"

    # Mengambil versi terbaru gotop
    gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v${gotop_latest}_linux_amd64.deb"

    # Download & install gotop
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1

    # Membuat swap file 2GB
    dd if=/dev/zero of=/swapfile bs=1M count=2048
    mkswap /swapfile
    chown root:root /swapfile
    chmod 0600 /swapfile
    swapon /swapfile >/dev/null 2>&1

    # Tambahkan swap ke fstab agar aktif saat boot
    sed -i '$ i\/swapfile swap swap defaults 0 0' /etc/fstab

    # Sinkronisasi waktu dengan server Indonesia
    chronyd -q 'server 0.id.pool.ntp.org iburst'
    chronyc sourcestats -v
    chronyc tracking -v

    # Download dan jalankan script BBR dari repo LUNAREP
    wget ${LUNAREP}configure/bbr.sh && chmod +x bbr.sh && ./bbr.sh

    print_success "Swap 2 GB berhasil dipasang"
}

# Fungsi: Menginstall Fail2ban dan setup banner SSH
FAIL2BAN_SETUP(){
    clear
    print_install "Menginstall Fail2ban"

    # Cek apakah folder DDOS sudah ada
    if [ -d '/usr/local/ddos' ]; then
        echo; echo; echo "Please un-install the previous version first"
        exit 0
    else
        mkdir /usr/local/ddos
    fi

    # Menambahkan banner login ke SSH
    echo "Banner /etc/banner.txt" >> /etc/ssh/sshd_config
    sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/banner.txt"@g' /etc/default/dropbear

    # Download file banner dari server
    wget -O /etc/banner.txt "${LUNAREP}banner/issue.net"

    print_success "Fail2ban berhasil diinstal"
}

WEBSOCKET_SETUP() {
    clear
    print_install "Menginstall ePro WebSocket Proxy"

    
    # Variabel file & URL
    local ws_bin="/usr/bin/ws"
    local tun_conf="/usr/bin/tun.conf"
    local ws_service="/etc/systemd/system/ws.service"
    local ltvpn_bin="/usr/sbin/ltvpn"
    local rclone_root="/root/.config/rclone/rclone.conf"
    local geosite="/usr/local/share/xray/geosite.dat"
    local geoip="/usr/local/share/xray/geoip.dat"

    # Unduh file binary dan konfigurasi
    wget -q -O "$ws_bin" "${LUNAREP}configure/ws"
    wget -q -O "$tun_conf" "${LUNAREP}configure/tun.conf"
    wget -q -O "$ws_service" "${LUNAREP}configure/ws.service"
    wget -q -O "$rclone_root" "${LUNAREP}configure/rclone.conf"
    wget ${LUNAREP}configure/dirmeluna.sh && chmod +x dirmeluna.sh && ./dirmeluna.sh
    # Izin akses
    chmod +x "$ws_bin"
    chmod 644 "$tun_conf"
    chmod +x "$ws_service"
    
    # Konfigurasi layanan systemd
    systemctl disable ws >/dev/null 2>&1
    systemctl stop ws >/dev/null 2>&1
    systemctl enable ws
    systemctl start ws
    systemctl restart ws
    systemctl restart socks

    # Update file geoip dan geosite untuk XRAY
    wget -q -O "$geosite" "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
    wget -q -O "$geoip" "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"

    # Unduh binary ftvpn
    wget -q -O "$ltvpn_bin" "${LUNAREP}configure/ltvpn"
    chmod +x "$ftvpn_bin"

    # Blokir lalu lintas BitTorrent via iptables
    local patterns=(
        "get_peers" "announce_peer" "find_node"
        "BitTorrent" "BitTorrent protocol" "peer_id="
        ".torrent" "announce.php?passkey=" "torrent"
        "announce" "info_hash"
    )
    for pattern in "${patterns[@]}"; do
        iptables -A FORWARD -m string --string "$pattern" --algo bm -j DROP
    done

    # Simpan aturan iptables
    iptables-save > /etc/iptables.up.rules
    iptables-restore < /etc/iptables.up.rules
    netfilter-persistent save
    netfilter-persistent reload

    # Bersihkan cache apt
    apt autoclean -y >/dev/null 2>&1
    apt autoremove -y >/dev/null 2>&1

    print_success "ePro WebSocket Proxy berhasil diinstal"
}

RESTART_SERVICE() {
    clear
    print_install "Restarting All Packet"

    # Restart service via init.d
    for srv in nginx openvpn ssh dropbear fail2ban vnstat cron; do
        /etc/init.d/$srv restart
    done

    # Restart systemd-based service
    systemctl restart haproxy

    # Enable semua service penting agar otomatis jalan saat boot
    for srv in nginx xray rc-local dropbear openvpn cron haproxy netfilter-persistent ws fail2ban; do
        systemctl enable --now $srv
    done

    # Reload systemctl
    systemctl daemon-reexec

    # Bersihkan history
    history -c
    echo "unset HISTFILE" >> /etc/profile

    # Bersihkan file temporer
    rm -f /root/openvpn /root/key.pem /root/cert.pem

    print_success "All services restarted & enabled"
}

MENU_SETUP() {
    clear
    print_install "Memasang Menu Packet"

    apt update -y
    apt install -y unzip

    wget https://raw.githubusercontent.com/script-VIP/v69/main/feature/LUNAVPN
    unzip LUNAVPN
    chmod +x menu/*
    mv menu/* /usr/local/sbin
#    dos2unix /usr/local/sbin/welcome
    
    rm -rf menu
    rm -rf menu.zip    
    # Bersihkan
    rm -rf menu LUNAVPN

    print_success "Menu berhasil dipasang"
}

BASHRC_PROFILE() {
clear
cat >/root/.profile <<EOF
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
menu
EOF
}

# Tambah Swap 1GB
fallocate -l 1G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Tambahkan ke fstab agar aktif setelah reboot
if ! grep -q "/swapfile" /etc/fstab; then
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# Optimalkan swappiness dan cache
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
sysctl -p

# ================================================
#     LUNATIC SYSTEM - CRONJOBS & AUTOSETUP
# ================================================

# === Cron: Auto-Expired Akun ===
cat > /etc/cron.d/xp_all <<-CRON
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/local/sbin/xp
CRON

# === Cron: Bersihkan Log Setiap 10 Menit ===
cat > /etc/cron.d/logclean <<-CRON
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/10 * * * * root /usr/local/sbin/clearlog
CRON

# === Cron: Reboot Otomatis Jam 5 Pagi ===
cat > /etc/cron.d/daily_reboot <<-CRON
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /sbin/reboot
CRON

# === Cron: Reboot Otomatis Jam 1 malam ===
cat > /etc/cron.d/autobackup <<-CRON
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 1 * * * root /usr/local/sbin/autobackup
CRON

# === Cron: Bersihkan Access Log Nginx & Xray Tiap Menit ===
echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" > /etc/cron.d/log.nginx
echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >> /etc/cron.d/log.xray

# === Restart Cron Service ===
service cron restart

# === Simpan Waktu Reboot Harian (5) ===
echo "5" > /home/daily_reboot

# === Konfigurasi rc-local systemd (untuk iptables dan startup command) ===
cat > /etc/systemd/system/rc-local.service <<-EOF
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF

# === Tambahkan Shell Non-Login untuk Keamanan ===
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells

# === Buat rc.local dengan aturan iptables untuk DNS UDP ===
cat > /etc/rc.local <<-EOF
#!/bin/sh -e
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF

chmod +x /etc/rc.local

# === Tambahan Informasi ===
AUTOREB=$(cat /home/daily_reboot)
SETT=11
if [ "$AUTOREB" -gt "$SETT" ]; then
    TIME_DATE="PM"
else
    TIME_DATE="AM"
fi

# === Output Informasi Sukses ===
echo -e "\e[92m✅ Cron dan Autostart Berhasil Ditetapkan ($TIME_DATE)\e[0m"

# ==========================================
# Function: ENABLED_SERVICE
# Deskripsi: Mengaktifkan dan me-restart layanan penting
# ==========================================
ENABLED_SERVICE() {
    clear
    print_install "Mengaktifkan Layanan Sistem..."

    systemctl daemon-reload
    systemctl start netfilter-persistent

    # Enable layanan penting saat boot
    systemctl enable --now rc-local
    systemctl enable --now cron
    systemctl enable --now netfilter-persistent

    # Restart service utama
    systemctl restart nginx
    systemctl restart xray
    systemctl restart cron
    systemctl restart haproxy
    systemctl restart dropbear
    systemctl restart ws
    systemctl restart ssh
    systemctl restart socks
    systemctl restart vlip
    systemctl restart vmip
    systemctl restart trip
    systemctl restart syslog
    print_success "Layanan Diaktifkan"
    clear
}
BOT_SHELL() {
   echo -e "\e[92;1m install shellbot \e[0m"
   wget https://raw.githubusercontent.com/ianexec/FINALIZED/main/LTbotVPN/SHELLBOT
    unzip SHELLBOT
    mv LTBOTVPN /usr/bin
    chmod +x /usr/bin/LTBOTVPN/*
    # HAPUS EXTRAK
    rm -rf SHELLBOT
      
}
REBUILD_INSTALL() {
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh
mv reinstall.sh /usr/bin
chmod +x /usr/bin/reinstall.sh
}

function SET_DETEK_SSH() {
detect_os() {
  if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    echo "$ID $VERSION_ID"
  else
    echo "Unknown"
  fi
}

os_version=$(detect_os)
if [[ "$os_version" =~ "ubuntu 24" ]]; then 
  RSYSLOG_FILE="/etc/rsyslog.d/50-default.conf"
elif [[ "$os_version" == "debian 12" ]]; then
  RSYSLOG_FILE="/etc/rsyslog.conf"
else
  echo "Sistem operasi atau versi tidak dikenali. Keluar..."
  #exit 1
fi

LOG_FILES=(
  "/var/log/auth.log"
  "/var/log/kern.log"
  "/var/log/mail.log"
  "/var/log/user.log"
  "/var/log/cron.log"
)

for log_file in "${LOG_FILES[@]}"; do
touch $log_file
done

set_permissions() {
  for log_file in "${LOG_FILES[@]}"; do
    if [[ -f "$log_file" ]]; then
      echo "Mengatur izin dan kepemilikan untuk $log_file..."
      chmod 640 "$log_file"
      chown syslog:adm "$log_file"
    else
      echo "$log_file tidak ditemukan, melewati..."
    fi
  done
}

# Mengecek apakah konfigurasi untuk dropbear sudah ada
check_dropbear_log() {
  grep -q 'if \$programname == "dropbear"' "$RSYSLOG_FILE"
}

# Fungsi untuk menambahkan konfigurasi dropbear
add_dropbear_log() {
  echo "Menambahkan konfigurasi Dropbear ke $RSYSLOG_FILE..."
  sudo bash -c "echo -e 'if \$programname == \"dropbear\" then /var/log/auth.log\n& stop' >> $RSYSLOG_FILE"
  systemctl restart rsyslog
  echo "Konfigurasi Dropbear ditambahkan dan Rsyslog direstart."
}

if check_dropbear_log; then
  echo "Konfigurasi Dropbear sudah ada, tidak ada perubahan yang dilakukan."
else
  add_dropbear_log
fi

# Set permissions untuk file log
set_permissions
}

ipsexx(){

# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
IZIN=$( curl ipinfo.io/ip | grep $MYIP )
if [ $MYIP = $MYIP ]; then
echo -e "${NC}${GREEN}Permission Accepted...${NC}"
else
echo -e "${NC}${RED}Permission Denied!${NC}";
echo -e "${NC}${LIGHT}Fuck You!!"
exit 0
fi

LUNASEC="raw.githubusercontent.com/fisabiliyusri/Mantap/main/ipsec"

VPN_IPSEC_PSK='myvpn'
NET_IFACE=$(ip -o $NET_IFACE -4 route show to default | awk '{print $5}');
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
source /etc/os-release
OS=$ID
ver=$VERSION_ID
bigecho() { echo; echo "## $1"; echo; }
bigecho "VPN setup in progress... Please be patient."

# Create and change to working dir
mkdir -p /opt/src
cd /opt/src

bigecho "Trying to auto discover IP of this server..."
PUBLIC_IP=$(wget -qO- ipinfo.io/ip);

bigecho "Installing packages required for the VPN..."
if [[ ${OS} == "centos" ]]; then
epel_url="https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm"
yum -y install epel-release || yum -y install "$epel_url" 

bigecho "Installing packages required for the VPN..."

REPO1='--enablerepo=epel'
REPO2='--enablerepo=*server-*optional*'
REPO3='--enablerepo=*releases-optional*'
REPO4='--enablerepo=PowerTools'

yum -y install nss-devel nspr-devel pkgconfig pam-devel \
  libcap-ng-devel libselinux-devel curl-devel nss-tools \
  flex bison gcc make ppp 

yum "$REPO1" -y install xl2tpd 


if [[ $ver == '7' ]]; then
  yum -y install systemd-devel iptables-services 
  yum "$REPO2" "$REPO3" -y install libevent-devel fipscheck-devel 
elif [[ $ver == '8' ]]; then
  yum "$REPO4" -y install systemd-devel libevent-devel fipscheck-devel 
fi
else
apt install openssl iptables iptables-persistent -y
apt-get -y install libnss3-dev libnspr4-dev pkg-config \
  libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev \
  libcurl4-nss-dev flex bison gcc make libnss3-tools \
  libevent-dev ppp xl2tpd pptpd
fi
bigecho "Compiling and installing Libreswan..."

SWAN_VER=3.32
swan_file="libreswan-$SWAN_VER.tar.gz"
swan_url1="https://github.com/libreswan/libreswan/archive/v$SWAN_VER.tar.gz"
swan_url2="https://download.libreswan.org/$swan_file"
if ! { wget -t 3 -T 30 -nv -O "$swan_file" "$swan_url1" || wget -t 3 -T 30 -nv -O "$swan_file" "$swan_url2"; }; then
  exit 1
fi
/bin/rm -rf "/opt/src/libreswan-$SWAN_VER"
tar xzf "$swan_file" && /bin/rm -f "$swan_file"
cd "libreswan-$SWAN_VER" || exit 1
cat > Makefile.inc.local <<'EOF'
WERROR_CFLAGS = -w
USE_DNSSEC = false
USE_DH2 = true
USE_DH31 = false
USE_NSS_AVA_COPY = true
USE_NSS_IPSEC_PROFILE = false
USE_GLIBC_KERN_FLIP_HEADERS = true
EOF
if ! grep -qs IFLA_XFRM_LINK /usr/include/linux/if_link.h; then
  echo "USE_XFRM_INTERFACE_IFLA_HEADER = true" >> Makefile.inc.local
fi
if [[ ${OS} == "debian" ]]; then
if [ "$(packaging/utils/lswan_detect.sh init)" = "systemd" ]; then
  apt-get -y install libsystemd-dev
  fi
elif [[ ${OS} == "ubuntu" ]]; then
if [ "$(packaging/utils/lswan_detect.sh init)" = "systemd" ]; then
  apt-get -y install libsystemd-dev
fi
fi
NPROCS=$(grep -c ^processor /proc/cpuinfo)
[ -z "$NPROCS" ] && NPROCS=1
make "-j$((NPROCS+1))" -s base && make -s install-base

cd /opt/src || exit 1
/bin/rm -rf "/opt/src/libreswan-$SWAN_VER"
if ! /usr/local/sbin/ipsec --version 2>/dev/null | grep -qF "$SWAN_VER"; then
  exiterr "Libreswan $SWAN_VER failed to build."
fi

bigecho "Creating VPN configuration..."

L2TP_NET=192.168.42.0/24
L2TP_LOCAL=192.168.42.1
L2TP_POOL=192.168.42.10-192.168.42.250
XAUTH_NET=192.168.43.0/24
XAUTH_POOL=192.168.43.10-192.168.43.250
DNS_SRV1=8.8.8.8
DNS_SRV2=8.8.4.4
DNS_SRVS="\"$DNS_SRV1 $DNS_SRV2\""
[ -n "$VPN_DNS_SRV1" ] && [ -z "$VPN_DNS_SRV2" ] && DNS_SRVS="$DNS_SRV1"

# Create IPsec config
cat > /etc/ipsec.conf <<EOF
version 2.0

config setup
  virtual-private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:!$L2TP_NET,%v4:!$XAUTH_NET
  protostack=netkey
  interfaces=%defaultroute
  uniqueids=no

conn shared
  left=%defaultroute
  leftid=$PUBLIC_IP
  right=%any
  encapsulation=yes
  authby=secret
  pfs=no
  rekey=no
  keyingtries=5
  dpddelay=30
  dpdtimeout=120
  dpdaction=clear
  ikev2=never
  ike=aes256-sha2,aes128-sha2,aes256-sha1,aes128-sha1,aes256-sha2;modp1024,aes128-sha1;modp1024
  phase2alg=aes_gcm-null,aes128-sha1,aes256-sha1,aes256-sha2_512,aes128-sha2,aes256-sha2
  sha2-truncbug=no

conn l2tp-psk
  auto=add
  leftprotoport=17/1701
  rightprotoport=17/%any
  type=transport
  phase2=esp
  also=shared

conn xauth-psk
  auto=add
  leftsubnet=0.0.0.0/0
  rightaddresspool=$XAUTH_POOL
  modecfgdns=$DNS_SRVS
  leftxauthserver=yes
  rightxauthclient=yes
  leftmodecfgserver=yes
  rightmodecfgclient=yes
  modecfgpull=yes
  xauthby=file
  ike-frag=yes
  cisco-unity=yes
  also=shared

include /etc/ipsec.d/*.conf
EOF

if uname -m | grep -qi '^arm'; then
  if ! modprobe -q sha512; then
    sed -i '/phase2alg/s/,aes256-sha2_512//' /etc/ipsec.conf
  fi
fi

# Specify IPsec PSK
cat > /etc/ipsec.secrets <<EOF
%any  %any  : PSK "$VPN_IPSEC_PSK"
EOF

# Create xl2tpd config
cat > /etc/xl2tpd/xl2tpd.conf <<EOF
[global]
port = 1701

[lns default]
ip range = $L2TP_POOL
local ip = $L2TP_LOCAL
require chap = yes
refuse pap = yes
require authentication = yes
name = l2tpd
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes
EOF

# Set xl2tpd options
cat > /etc/ppp/options.xl2tpd <<EOF
+mschap-v2
ipcp-accept-local
ipcp-accept-remote
noccp
auth
mtu 1280
mru 1280
proxyarp
lcp-echo-failure 4
lcp-echo-interval 30
connect-delay 5000
ms-dns $DNS_SRV1
EOF

if [ -z "$VPN_DNS_SRV1" ] || [ -n "$VPN_DNS_SRV2" ]; then
cat >> /etc/ppp/options.xl2tpd <<EOF
ms-dns $DNS_SRV2
EOF
fi

# Create VPN credentials
cat > /etc/ppp/chap-secrets <<EOF
"$VPN_USER" l2tpd "$VPN_PASSWORD" *
EOF

VPN_PASSWORD_ENC=$(openssl passwd -1 "$VPN_PASSWORD")
cat > /etc/ipsec.d/passwd <<EOF
$VPN_USER:$VPN_PASSWORD_ENC:xauth-psk
EOF

# Create PPTP config
cat >/etc/pptpd.conf <<END
option /etc/ppp/options.pptpd
logwtmp
localip 192.168.41.1
remoteip 192.168.41.10-100
END
cat >/etc/ppp/options.pptpd <<END
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
lock
nobsdcomp 
novj
novjccomp
nologfd
END

bigecho "Updating IPTables rules..."
service fail2ban stop >/dev/null 2>&1
iptables -t nat -I POSTROUTING -s 192.168.43.0/24 -o $NET_IFACE -j MASQUERADE
iptables -t nat -I POSTROUTING -s 192.168.42.0/24 -o $NET_IFACE -j MASQUERADE
iptables -t nat -I POSTROUTING -s 192.168.41.0/24 -o $NET_IFACE -j MASQUERADE
if [[ ${OS} == "centos" ]]; then
service iptables save
iptables-restore < /etc/sysconfig/iptables 
else
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
fi

bigecho "Enabling services on boot..."
systemctl enable xl2tpd
systemctl enable ipsec
systemctl enable pptpd

for svc in fail2ban ipsec xl2tpd; do
  update-rc.d "$svc" enable >/dev/null 2>&1
  systemctl enable "$svc" 2>/dev/null
done

bigecho "Starting services..."
sysctl -e -q -p
chmod 600 /etc/ipsec.secrets* /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*

mkdir -p /run/pluto
service fail2ban restart 2>/dev/null
service ipsec restart 2>/dev/null
service xl2tpd restart 2>/dev/null
touch /var/lib/luna/data-user-l2tp
touch /var/lib/luna/data-user-pptp
}
# ==========================================
# Function: instal
# Deskripsi: Proses instalasi dan konfigurasi semua layanan
# ==========================================
function RUN() {
    clear
    PROXY_SETUP            # Inisialisasi pertama
    TOOLS_SETUP            # Instalasi paket dasar
    FODER_SETUP            # Membuat folder untuk Xray
    DOMENS_SETUP           # Menyetel domain
    SSL_SETUP              # Memasang SSL
    XRAY_SETUP             # Instalasi Xray core
    PW_DEFAULT             # Instalasi SSH dan dependensi
    LIMIT_HANDLER          # Instalasi Limit ip quota
   # SLOWDNS_SETUP          # SSH SlowDNS
    SSHD_SETUP             # Konfigurasi SSHD
    DROPBEAR_SETUP         # Instalasi Dropbear
    vnSTATS_SETUP          # Monitoring bandwidth
    OPVPN_SETUP            # OpenVPN
    RCLONE_SETUP           # Auto Backup system
    SWAPRAM_SETUP          # Instalasi Swap & Autoreboot
    FAIL2BAN_SETUP         # Proteksi brute-force login
    WEBSOCKET_SETUP        # Custom script tambahan
    RESTART_SERVICE        # Restart semua layanan
    MENU_SETUP             # Pasang menu CLI
    BASHRC_PROFILE         # Update environment profile
    ENABLED_SERVICE        # Aktifkan semua service
    BOT_SHELL
    REBUILD_INSTALL
#    SET_DETEK_SSH
}

# ==========================================
# Eksekusi Instalasi
# ==========================================
RUN
UDEPE
echo ""

# ==========================================
# Pembersihan Jejak Instalasi
# ==========================================
history -c
echo "unset HISTFILE" >> /etc/profile

rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
rm -rf /root/domain
rm -rf /root/dropbear-*
# ==========================================
# Pesan Sukses
# ==========================================
echo -e "${green} ✅ Instalasi selesai dengan sukses! ${NC}"
sleep 1
reboot
