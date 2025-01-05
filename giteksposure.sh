#!/bin/bash

# File : giteksposure.sh
# Description : Skrip ini dibuat untuk mencari subdomain dan mendeteksi kerentanan .git exposure pada subdomain.

if [ $# -lt 1 ]; then 
    echo "Usage: $0 <domain>"
    echo "Example: $0 tesla.com"
    exit 1
fi 

DOMAIN=$1

# Definisikan output nama file berdasarkan domain
SUBDOMAINS_FILE="${DOMAIN}-subdomain_list.txt"
EXPOSURE_FILE="${DOMAIN}-git_exposure_results.txt"

# Warna ANSI
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Tampilkan pesan awal
echo "Fetching subdomains for ${DOMAIN} and its assets from crt.sh . . ."

# Ambil data dari crt.sh dengan wildcard
SUBDOMAINS=$(curl -s "https://crt.sh/?q=%25${DOMAIN}&output=json" | jq -r '.[].name_value' 2>/dev/null | sort -u)

# Cek jika crt.sh mengembalikan hasil apapun
if [ -z "$SUBDOMAINS" ]; then 
    echo "No subdomains found on crt.sh. Trying alternative tools (assetfinder) . . ."

    # Gunakan assetfinder atau tool lainnya sebagai fallback
    SUBDOMAINS=$(assetfinder --subs-only $DOMAIN | sort -u)
    if [ -z "$SUBDOMAINS" ]; then
        echo "No subdomains found. Exiting."
        exit 1
    fi 
fi 

# Simpan subdomain ke file
echo "$SUBDOMAINS" > "$SUBDOMAINS_FILE"

# Tampilkan total subdomain yang ditemukan
echo "Total subdomains found: $(echo "$SUBDOMAINS" | wc -l)"

# Proses subdomain dan cek untuk git exposure
echo "Scanning for git exposure on subdomains. . ."
echo "$SUBDOMAINS" | \
    sed 's#$#/.git/HEAD#' | \
    httpx -silent -no-color -content-length -status-code -timeout 3 -retries 0 \
    -ports 80,8000,443 -threads 500 -title | while read -r line; do
    STATUS=$(echo "$line" | awk '{print $2}' | sed 's/[^0-9]//g') # Ambil hanya angka dari status code
    if [[ "$STATUS" == "200" ]]; then
        echo -e "${GREEN}${line}${RESET}" >> "$EXPOSURE_FILE"
    elif [[ "$STATUS" == "301" || "$STATUS" == "302" ]]; then
        echo -e "${YELLOW}${line}${RESET}" >> "$EXPOSURE_FILE"
    elif [[ "$STATUS" == "403" ]]; then
        echo -e "${BLUE}${line}${RESET}" >> "$EXPOSURE_FILE"
    else
        echo -e "${RED}${line}${RESET}" >> "$EXPOSURE_FILE"
    fi
done

# Tampilkan pesan setelah proses selesai
echo "Scan complete. Results saved to:"
echo "- Subdomain list: $SUBDOMAINS_FILE"
echo "- Git Exposure result: $EXPOSURE_FILE"
