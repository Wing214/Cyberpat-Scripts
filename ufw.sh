#!/bin/bash

# Install ufw if it's not already installed
if ! dpkg -l | grep -q ufw; then
    sudo apt install ufw -y
fi

# Set up UFW rules
ufw disable
ufw reset

# Allowed and denied ports
ufw allow 80 21 3307 53 137 138 139 445 8200
ufw allow out 22
ufw deny 23 1080 5554 2745 3127 4444 8866 9898 9988 12345 27374 31337

# Remove specified packages
packages=(
    aircrack-ng Nessus Snort Burp maltego fern wireshark nmap netcat john ophcrack hydra 
    crack telnet weplab niktgo kismet freeciv sn1per metasploit-framework owasp pig 
    SPARTA Zarp dsniff scapy PRET Praeda routersploit impacket dnstwist hping3 rshijack 
    pwnat tgcd lodine dnsrecon wifite airgeddon cowpatty boopsuite Bully weevely3
)
for pkg in "${packages[@]}"; do
    apt remove "$pkg" -y
done

# Create and populate BadFiles.txt with specified file types
touch BadFiles.txt
locate "password.*" "*.txt" "*.mp3" "*.mp4" >> BadFiles.txt
