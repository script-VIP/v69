#!/bin/bash

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Base path
BASE_PATH="/root/LTBOTWA/cmd/"

display_menu() {
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}🎨  MENU EDIT BOT FILE - PATH LOKAL  🎨${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    
    # Function to print file
    print_file() {
        local num=$1
        local file=$2
        local full_path="${BASE_PATH}${file}"
        
        if [ -f "$full_path" ]; then
            case $file in
                *ai.js*) echo -e "${GREEN}$num. 🤖  $file ✅${NC}" ;;
                *vps*) echo -e "${BLUE}$num. 💻  $file ✅${NC}" ;;
                *del*|*ban*) echo -e "${RED}$num. 🗑️  $file ✅${NC}" ;;
                *owner*) echo -e "${YELLOW}$num. 👑  $file ✅${NC}" ;;
                *cmd*) echo -e "${PURPLE}$num. ⚡  $file ✅${NC}" ;;
                *menu*|*list*) echo -e "${CYAN}$num. 📋  $file ✅${NC}" ;;
                *) echo -e "${WHITE}$num. 📄  $file ✅${NC}" ;;
            esac
        else
            echo -e "${RED}$num. ❌  $file (Not Found)${NC}"
        fi
    }

    echo -e "${YELLOW}📁 FILE YANG TERSEDIA:${NC}"
    echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"
    
    print_file 1 "adcmd.js"
    print_file 2 "addowner.js"
    print_file 3 "adssh.js"
    print_file 4 "adtokengh.js"
    print_file 5 "adtro.js"
    print_file 6 "advle.js"
    print_file 7 "advme.js"
    print_file 8 "advps.js"
    print_file 9 "ai.js"
    print_file 10 "ban.js"
    print_file 11 "buatvps.js"
    print_file 12 "cekvps.js"
    print_file 13 "crackmail.js"
    print_file 14 "del.js"
    print_file 15 "delcmd.js"
    print_file 16 "dellowner.js"
    print_file 17 "delregist.js"
    print_file 18 "delvps.js"
    print_file 19 "demote.js"
    print_file 20 "gclink.js"
    print_file 21 "getcmd.js"
    print_file 22 "gh.js"
    print_file 23 "halo.js"
    print_file 24 "igdl.js"
    print_file 25 "indopromo.js"
    print_file 26 "installsc.js"
    print_file 27 "jualan.js"
    print_file 28 "jualan.js.bak"
    print_file 29 "kik.js"
    print_file 30 "listemd.js"
    print_file 31 "listimages.js"
    print_file 32 "listowner.js"
    print_file 33 "listregist.js"
    print_file 34 "listvps.js"
    print_file 35 "menu.js"
    print_file 36 "onprefix.js"
    print_file 37 "pay.js"
    print_file 38 "promosi.js"
    print_file 39 "promote.js"
    print_file 40 "qrjs"
    print_file 41 "rebuild.js"
    print_file 42 "registip.js"
    print_file 43 "reip.js"
    print_file 44 "set.js"
    print_file 45 "system.js"
    print_file 46 "ttdl.js"
    print_file 47 "unban.js"
    print_file 48 "view.js"
    print_file 49 "vpstunnel.js"

    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
}

open_file() {
    local choice=$1
    local file_name=""
    
    case $choice in
        1) file_name="adcmd.js" ;;
        2) file_name="addowner.js" ;;
        3) file_name="adssh.js" ;;
        4) file_name="adtokengh.js" ;;
        5) file_name="adtro.js" ;;
        6) file_name="advle.js" ;;
        7) file_name="advme.js" ;;
        8) file_name="advps.js" ;;
        9) file_name="ai.js" ;;
        10) file_name="ban.js" ;;
        11) file_name="buatvps.js" ;;
        12) file_name="cekvps.js" ;;
        13) file_name="crackmail.js" ;;
        14) file_name="del.js" ;;
        15) file_name="delcmd.js" ;;
        16) file_name="dellowner.js" ;;
        17) file_name="delregist.js" ;;
        18) file_name="delvps.js" ;;
        19) file_name="demote.js" ;;
        20) file_name="gclink.js" ;;
        21) file_name="getcmd.js" ;;
        22) file_name="gh.js" ;;
        23) file_name="halo.js" ;;
        24) file_name="igdl.js" ;;
        25) file_name="indopromo.js" ;;
        26) file_name="installsc.js" ;;
        27) file_name="jualan.js" ;;
        28) file_name="jualan.js.bak" ;;
        29) file_name="kik.js" ;;
        30) file_name="listemd.js" ;;
        31) file_name="listimages.js" ;;
        32) file_name="listowner.js" ;;
        33) file_name="listregist.js" ;;
        34) file_name="listvps.js" ;;
        35) file_name="menu.js" ;;
        36) file_name="onprefix.js" ;;
        37) file_name="pay.js" ;;
        38) file_name="promosi.js" ;;
        39) file_name="promote.js" ;;
        40) file_name="qrjs" ;;
        41) file_name="rebuild.js" ;;
        42) file_name="registip.js" ;;
        43) file_name="reip.js" ;;
        44) file_name="set.js" ;;
        45) file_name="system.js" ;;
        46) file_name="ttdl.js" ;;
        47) file_name="unban.js" ;;
        48) file_name="view.js" ;;
        49) file_name="vpstunnel.js" ;;
        *) return 1 ;;
    esac
    
    local full_path="${BASE_PATH}${file_name}"
    
    if [ -f "$full_path" ]; then
        echo -e "${GREEN}✅ Membuka: $file_name${NC}"
        nano "$full_path"
        return 0
    else
        echo -e "${RED}❌ File tidak ditemukan: $full_path${NC}"
        return 1
    fi
}

# Main program
while true; do
    clear
    display_menu
    
    echo -e "${YELLOW}📝 Pilih nomor file (1-49) atau 'q' untuk keluar:${NC}"
    read -p ">> " choice
    
    case $choice in
        [1-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9])
            open_file $choice
            ;;
        q|Q)
            echo -e "${CYAN}👋 Keluar...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Pilihan tidak valid!${NC}"
            sleep 2
            ;;
    esac
    
    echo -e "${YELLOW}↵ Tekan Enter untuk melanjutkan...${NC}"
    read
done
