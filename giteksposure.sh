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

echo "Total subdomains found: $(echo "$SUBDOMAINS" | wc -l)"
echo "$SUBDOMAINS" > "$SUBDOMAINS_FILE"

# Proses subdomain dan cek untuk git exposure
echo "Scanning for git exposure on subdomains. . ."
echo "$SUBDOMAINS" | \
    sed 's#$#/.git/HEAD#' | \
    httpx -silent -no-color -content-length -status-code 200,301,302 -timeout 3 -retries 0 \
    -ports 80,8000,443 -threads 500 -title | \
    anew > "$EXPOSURE_FILE"

echo "Scan complete. Results saved to:"
echo "- Subdomain list: $SUBDOMAINS_FILE"
echo "- Git Exposure result: $EXPOSURE_FILE"
