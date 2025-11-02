
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

echo -e "${CYAN}$LINE${NC}"
echo -e "${WHITE}🎨  MENU EDIT BOT FILE - COLORED VERSION  🎨${NC}"
echo -e "${CYAN}$LINE${NC}"

# Function to print file with color based on type
print_file() {
    local num=$1
    local file=$2
    local size=$3
    
    case $file in
        *ai.js*) echo -e "${GREEN}$num. 🤖  $file - $size${NC}" ;;
        *vps*) echo -e "${BLUE}$num. 💻  $file - $size${NC}" ;;
        *del*|*ban*|*unban*) echo -e "${RED}$num. 🗑️  $file - $size${NC}" ;;
        *owner*|*promote*|*demote*) echo -e "${YELLOW}$num. 👑  $file - $size${NC}" ;;
        *cmd*) echo -e "${PURPLE}$num. ⚡  $file - $size${NC}" ;;
        *menu*|*list*) echo -e "${CYAN}$num. 📋  $file - $size${NC}" ;;
        *) echo -e "${WHITE}$num. 📄  $file - $size${NC}" ;;
    esac
}

echo -e "${YELLOW}📁 SCRIPT MANAGEMENT FILES${NC}"
echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

# Print files 1-10
for i in {1..10}; do
    case $i in
        1) print_file 1 "adcmd.js" "1.00KB" ;;
        2) print_file 2 "addowner.js" "840.00B" ;;
        3) print_file 3 "adssh.js" "3.21KB" ;;
        4) print_file 4 "adtokengh.js" "755.00B" ;;
        5) print_file 5 "adtro.js" "1.86KB" ;;
        6) print_file 6 "advle.js" "1.96KB" ;;
        7) print_file 7 "advme.js" "1.96KB" ;;
        8) print_file 8 "advps.js" "859.00B" ;;
        9) print_file 9 "ai.js" "1.20KB" ;;
        10) print_file 10 "ban.js" "811.00B" ;;
    esac
done

echo -e "${YELLOW}🔧 VPS & SYSTEM FILES${NC}"
echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

# Print files 11-20
for i in {11..20}; do
    case $i in
        11) print_file 11 "buatvps.js" "3.76KB" ;;
        12) print_file 12 "cekvps.js" "866.00B" ;;
        13) print_file 13 "crackmail.js" "1.12KB" ;;
        14) print_file 14 "del.js" "988.00B" ;;
        15) print_file 15 "delcmd.js" "587.00B" ;;
        16) print_file 16 "dellowner.js" "766.00B" ;;
        17) print_file 17 "delregist.js" "1.97KB" ;;
        18) print_file 18 "delvps.js" "1.65KB" ;;
        19) print_file 19 "demote.js" "1.78KB" ;;
        20) print_file 20 "gclink.js" "722.00B" ;;
    esac
done

echo -e "${YELLOW}📊 UTILITY FILES${NC}"
echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

# Print files 21-30
for i in {21..30}; do
    case $i in
        21) print_file 21 "getcmd.js" "622.00B" ;;
        22) print_file 22 "gh.js" "1.48KB" ;;
        23) print_file 23 "halo.js" "1.33KB" ;;
        24) print_file 24 "igdl.js" "1.75KB" ;;
        25) print_file 25 "indopromo.js" "1.28KB" ;;
        26) print_file 26 "installsc.js" "1.27KB" ;;
        27) print_file 27 "jualan.js" "1.64KB" ;;
        28) print_file 28 "jualan.js.bak" "1.66KB" ;;
        29) print_file 29 "kik.js" "1.56KB" ;;
        30) print_file 30 "listemd.js" "462.00B" ;;
    esac
done

echo -e "${YELLOW}📋 LIST & MENU FILES${NC}"
echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

# Print files 31-40
for i in {31..40}; do
    case $i in
        31) print_file 31 "listimages.js" "1.65KB" ;;
        32) print_file 32 "listowner.js" "556.00B" ;;
        33) print_file 33 "listregist.js" "1.84KB" ;;
        34) print_file 34 "listvps.js" "1.57KB" ;;
        35) print_file 35 "menu.js" "2.74KB" ;;
        36) print_file 36 "onprefix.js" "447.00B" ;;
        37) print_file 37 "pay.js" "359.00B" ;;
        38) print_file 38 "promosi.js" "1.64KB" ;;
        39) print_file 39 "promote.js" "1.55KB" ;;
        40) print_file 40 "qrjs" "556.00B" ;;
    esac
done

echo -e "${YELLOW}⚙️ SYSTEM FILES${NC}"
echo -e "${GREEN}────────────────────────────────────────────────────────────────${NC}"

# Print files 41-49
for i in {41..49}; do
    case $i in
        41) print_file 41 "rebuild.js" "1.89KB" ;;
        42) print_file 42 "registip.js" "2.41KB" ;;
        43) print_file 43 "reip.js" "2.34KB" ;;
        44) print_file 44 "set.js" "1.12KB" ;;
        45) print_file 45 "system.js" "1.92KB" ;;
        46) print_file 46 "ttdl.js" "1.28KB" ;;
        47) print_file 47 "unban.js" "733.00B" ;;
        48) print_file 48 "view.js" "1.54KB" ;;
        49) print_file 49 "vpstunnel.js" "794.00B" ;;
    esac
done

echo -e "${CYAN}$LINE${NC}"
echo -e "${WHITE}🎯 Total: 49 Files Available 🎯${NC}"
echo -e "${CYAN}$LINE${NC}"

# Usage instructions
echo -e "${YELLOW}📝 Usage:${NC}"
echo -e "${GREEN}• Select file number to edit${NC}"
echo -e "${GREEN}• Type 'q' to quit${NC}"
echo -e "${GREEN}• Type 'help' for assistance${NC}"
echo -e "${CYAN}$LINE${NC}"
