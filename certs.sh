#!/bin/bash

# Directory to store certs
CERT_DIR="$HOME/mycerts"

mkdir -p "$CERT_DIR"

ip=$(timeout 3 curl -4 -s icanhazip.com)

openssl genrsa -out "$CERT_DIR/secret.key" 2048
openssl req -key "$CERT_DIR/secret.key" -new -out "$CERT_DIR/cert.csr" -nodes \
  -subj "/C=AU/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=$ip" \
  -addext "subjectAltName=DNS:$ip,DNS:*.$ip,IP:$ip"
openssl x509 -signkey "$CERT_DIR/secret.key" -in "$CERT_DIR/cert.csr" -req -days 3650 -out "$CERT_DIR/cert.crt"

echo -e "\033[32mPath to certificate (public key):\033[0m"
echo -e "\033[31m$CERT_DIR/cert.crt\033[0m"

echo -e "\033[32mPath to private key:\033[0m"
echo -e "\033[31m$CERT_DIR/secret.key\033[0m"
