#!/bin/sh

print_breaker() {
    echo "-----------------------------------------------"
}
. /config.sh

# #####################################################################
# functions to get public ip
get_ip4() {
  CURRENT_IP=$(curl -s https://ipv4.icanhazip.com/ || curl -s https://api.ipify.org)
  if [ -z $CURRENT_IP ]; then
    dig_ip=$(dig txt ch +short whoami.cloudflare @1.1.1.1)
    if [ "$?" = 0 ]; then
      CURRENT_IP=$(echo $dig_ip | tr -d '"')
    else
      exit 1
    fi
  fi
  echo $CURRENT_IP
}

get_ip6() {
  CURRENT_IP=$(curl -s https://ipv6.icanhazip.com/ || curl -s https://api6.ipify.org)
  if [ -z $CURRENT_IP ]; then
    dig_ip=$(dig txt ch +short whoami.cloudflare @2606:4700:4700::1111)
    if [ "$?" = 0 ]; then
      CURRENT_IP=$(echo $dig_ip | tr -d '"')
    else
      exit 1
    fi
  fi
  echo $CURRENT_IP
}
# #####################################################################
# Step 1: get public IP address
echo Fetching record type: $RECORD_TYPE
if [ "$RECORD_TYPE" == "A" ]; then
	CURRENT_IP=$(curl -s https://api.ipify.org || curl -s https://ipv4.icanhazip.com/)

	# check cloudflare's dns server if above method doesn't work
	if [ -z $CURRENT_IP ]; then
		echo using cloudflare whoami to find ip
    CURRENT_IP=$(dig txt ch +short whoami.cloudflare @1.1.1.1 | tr -d '"')
	fi
elif [ "$RECORD_TYPE" == "AAAA" ]; then
	CURRENT_IP=$(curl -s https://api6.ipify.org || curl -s https://ipv6.icanhazip.com/)

	# check cloudflare's dns server if above method doesn't work
	if [ -z $CURRENT_IP ]; then
		echo using cloudflare whoami to find ip
    CURRENT_IP=$(dig txt ch +short whoami.cloudflare @2606:4700:4700::1111 | tr -d '"')
	fi
fi

if [ -z $CURRENT_IP ]; then
    echo "No public IP found: check internet connection or network settings"
    exit 1
fi
echo "Current time: [$(date)]"
echo "Current Public IP: $CURRENT_IP"

# #####################################################################
# Step 2: Update ddns
OLD_IP=$(cat /old_record_ip)
echo "Stored IP address: $OLD_IP"
if [ "$OLD_IP" == "$CURRENT_IP" ]; then
    echo "IP address has not changed. Update not required"
    print_breaker
    exit 0
fi
echo "IP address has changed. Updating DuckDNS..."
if [ "$RECORD_TYPE" == "A" ]; then
  update=$(curl -s "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=${CURRENT_IP}")
elif [ "$RECORD_TYPE" == "AAAA" ]; then
  update=$(curl -s "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ipv6=${CURRENT_IP}")
fi

if [ "$update" == "OK" ]; then
  echo "DNS Record for $SUBDOMAINS successfully updated to: $CURRENT_IP"
  echo $CURRENT_IP > /old_record_ip
else
  echo "DuckDNS update failed"
fi
