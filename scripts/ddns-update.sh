#!/bin/sh

. /config.sh

# curl "https://www.duckdns.org/update?domains=${duck_subdomain}&token=${duck_token}&ip="
# info=$(echo url="https://www.duckdns.org/update?domains=${duck_subdomain}&token=${duck_token}&ip=" | curl -s -k -K - )
update=$(curl -sSL "https://www.duckdns.org/update?domains=${SUBDOMAINS}&token=${TOKEN}&ip=")

if [ "$update" == "OK" ]; then
  echo "[$(date)] DuckDNS update ok"
else
  echo "[$(date)] DuckDNS update failed"
fi
