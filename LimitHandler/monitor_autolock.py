#!/bin/bash
Send_Logging() {
    # Membaca KEY dan ID Telegram hanya sekali
    KEY_TELE=$(< /etc/lunatic/bot/notif/key)
    ID_TELE=$(< /etc/lunatic/bot/notif/id)

    # Cek apakah KEY_TELE dan ID_TELE ada
    if [[ -z "$KEY_TELE" || -z "$ID_TELE" ]]; then
        return  # Tidak ada key atau ID, keluar dari fungsi
    fi

    TEXT="
<code>====================</code>
<code>MULTI LOGIN XRAY</code>
<code>====================</code>
<code> TYPE XRAY: SDWSOK  </code>
<code> USERNAME : $USERNAME </code>
<code> LIMIT IP : $MAX_IP</code>
<code> LOGIN IP : $LOGIN_IP </code>
<code>====================</code>
<code> Locked 15 minutes </code>
<code>====================</code>
"

    curl -s -X POST "https://api.telegram.org/bot${KEY_TELE}/sendMessage" \
         -d "chat_id=$ID_TELE" \
         -d "text=$TEXT" \
         -d "parse_mode=HTML" > /dev/null
}

# Simpan log sementara untuk menghindari kehilangan data
cp /var/log/xray/accessvme.log /tmp/accessvme.log
echo -n > /var/log/xray/accessvme.log
sleep 60

# Ambil daftar pengguna dari direktori batasan IP
declare -a data=($(ls /etc/lunatic/vmess/ip))
for USERNAME in "${data[@]}"; do
    MAX_IP=$(cat /etc/lunatic/vmess/ip/$USERNAME 2>/dev/null)
    if [[ -z "$MAX_IP" ]]; then
        echo "File batasan IP untuk $USERNAME tidak ditemukan, lewati."
        continue
    fi

    IP_DI_AKSES=$(grep "$USERNAME" /tmp/accessvme.log | grep -Eo 'tcp://[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | cut -d "/" -f 3 | cut -d ":" -f 1 | sort | uniq)
    LOGIN_IP=$(echo "$IP_DI_AKSES" | wc -l)

    if [[ $LOGIN_IP -gt $MAX_IP ]]; then
        sed -i "/### $USERNAME /{n;s/^/#/}" /etc/xray/config.json
        systemctl restart xray >> /dev/null 2>&1

        Send_Logging

        echo "echo 'sed -i \"/### $USERNAME /{n;s/^#//}\" /etc/xray/config.json && systemctl restart xray && systemctl restart vmejs >> /dev/null 2>&1' | at now + 15 minutes" | bash
    fi
    sleep 0.1
done
