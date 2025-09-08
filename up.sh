#!/bin/bash
clear

# Mengunduh dan mengekstrak menu
echo -e "\033[32;1m Install packages.... \033[0m"
apt update -y
apt install -y unzip

clear
echo -e "\033[32;1m Download New Menu.... \033[0m"

    wget https://raw.githubusercontent.com/script-VIP/v69/main/feature/LUNAVPN
    unzip LUNAVPN

clear
    
    chmod +x menu/*
    mv menu/* /usr/local/sbin
    dos2unix /usr/local/sbin/welcome
    
    rm -rf menu
    rm -rf LUNAVPN

clear
echo -e "\033[31;1m ============================ \033[0m"
echo -e "\033[32;1m Script successfully updated. \033[0m"
echo -e "\033[31;1m ============================ \033[0m"
sleep 2
welcome
