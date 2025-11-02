#!/bin/bash

# Colors for output
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Line separator
LINE="════════════════════════════════════════════════════════════════════════════════"

# Function to display menu
display_menu() {
    echo -e "${CYAN}$LINE${NC}"
    echo -e "${WHITE}🎨  MENU EDIT BOT FILE  🎨${NC}"
    echo -e "${CYAN}$LINE${NC}"

    # Function to print file with color based on type
    print_file() {
        local num=$1
        local file=$2
        
        case $file in
            *ai.js*) echo -e "${GREEN}$num. 🤖  $file${NC}" ;;
            *vps*) echo -e "${BLUE}$num. 💻  $file${NC}" ;;
            *del*|*ban*|*unban*) echo -e "${RED}$num. 🗑️  $file${NC}" ;;
            *owner*|*promote*|*demote*) echo -e "${YELLOW}$num. 👑  $file${NC}" ;;
            *cmd*) echo -e "${PURPLE}$num. ⚡  $file${NC}" ;;
            *menu*|*list*) echo -e "${CYAN}$num. 📋  $file${NC}" ;;
            *) echo -e "${WHITE}$num. 📄  $file${NC}" ;;
        esac
    }

    echo -e "${YELLOW}📁 SCRIPT MANAGEMENT FILES${NC}"
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

    echo -e "${YELLOW}🔧 VPS & SYSTEM FILES${NC}"
    echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

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

    echo -e "${YELLOW}📊 UTILITY FILES${NC}"
    echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

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

    echo -e "${YELLOW}📋 LIST & MENU FILES${NC}"
    echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

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

    echo -e "${YELLOW}⚙️ SYSTEM FILES${NC}"
    echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

    print_file 41 "rebuild.js"
    print_file 42 "registip.js"
    print_file 43 "reip.js"
    print_file 44 "set.js"
    print_file 45 "system.js"
    print_file 46 "ttdl.js"
    print_file 47 "unban.js"
    print_file 48 "view.js"
    print_file 49 "vpstunnel.js"

    echo -e "${CYAN}$LINE${NC}"
    echo -e "${WHITE}🎯 Total: 49 Files Available 🎯${NC}"
    echo -e "${CYAN}$LINE${NC}"
}

# Function to handle file selection
select_file() {
    while true; do
        echo -e "${YELLOW}📝 Pilih nomor file (1-49) atau ketik 'q' untuk keluar:${NC}"
        read -p ">> " choice
        
        case $choice in
            [1-9]|1[0-9]|2[0-9]|3[0-9]|4[0-9])
                if [ $choice -ge 1 ] && [ $choice -le 49 ]; then
                    case $choice in
                        1) file="adcmd.js" ;;
                        2) file="addowner.js" ;;
                        3) file="adssh.js" ;;
                        4) file="adtokengh.js" ;;
                        5) file="adtro.js" ;;
                        6) file="advle.js" ;;
                        7) file="advme.js" ;;
                        8) file="advps.js" ;;
                        9) file="ai.js" ;;
                        10) file="ban.js" ;;
                        11) file="buatvps.js" ;;
                        12) file="cekvps.js" ;;
                        13) file="crackmail.js" ;;
                        14) file="del.js" ;;
                        15) file="delcmd.js" ;;
                        16) file="dellowner.js" ;;
                        17) file="delregist.js" ;;
                        18) file="delvps.js" ;;
                        19) file="demote.js" ;;
                        20) file="gclink.js" ;;
                        21) file="getcmd.js" ;;
                        22) file="gh.js" ;;
                        23) file="halo.js" ;;
                        24) file="igdl.js" ;;
                        25) file="indopromo.js" ;;
                        26) file="installsc.js" ;;
                        27) file="jualan.js" ;;
                        28) file="jualan.js.bak" ;;
                        29) file="kik.js" ;;
                        30) file="listemd.js" ;;
                        31) file="listimages.js" ;;
                        32) file="listowner.js" ;;
                        33) file="listregist.js" ;;
                        34) file="listvps.js" ;;
                        35) file="menu.js" ;;
                        36) file="onprefix.js" ;;
                        37) file="pay.js" ;;
                        38) file="promosi.js" ;;
                        39) file="promote.js" ;;
                        40) file="qrjs" ;;
                        41) file="rebuild.js" ;;
                        42) file="registip.js" ;;
                        43) file="reip.js" ;;
                        44) file="set.js" ;;
                        45) file="system.js" ;;
                        46) file="ttdl.js" ;;
                        47) file="unban.js" ;;
                        48) file="view.js" ;;
                        49) file="vpstunnel.js" ;;
                    esac
                    
                    echo -e "${GREEN}✅ File dipilih: $file${NC}"
                    echo -e "${YELLOW}🚀 Membuka file untuk edit...${NC}"
                    # Ganti dengan editor pilihan Anda
                    nano $file
                    break
                else
                    echo -e "${RED}❌ Nomor tidak valid! Pilih 1-49${NC}"
                fi
                ;;
            q|Q)
                echo -e "${CYAN}👋 Keluar dari menu...${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Input tidak valid!${NC}"
                ;;
        esac
    done
}

# Main program
clear
display_menu
select_file
