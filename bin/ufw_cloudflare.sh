#!/bin/sh
ipv4_tmp="$(mktemp -t ips-v4)"
ipv6_tmp="$(mktemp -t ips-v6)"
wget https://www.cloudflare.com/ips-v4 -O "$ipv4_tmp"
wget https://www.cloudflare.com/ips-v6 -O "$ipv6_tmp"

while read -r cfip < "$ipv4_tmp"; do echo "ufw allow from $cfip to any app cloudflare-origin"; done
while read -r cfip < "$ipv6_tmp"; do echo "ufw allow from $cfip to any app cloudflare-origin"; done
#while read -r cfip < "$ipv4_tmp"; do echo "ufw allow from $cfip to any port 443 proto tcp"; done
#while read -r cfip < "$ipv6_tmp"; do echo "ufw allow from $cfip to any port 443 proto tcp"; done
