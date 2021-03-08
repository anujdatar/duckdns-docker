#!/bin/sh

if [ -z $SUBDOMAINS ]; then
  if [ -z $SUBDOMAINS_FILE ]; then
    echo 'Please enter DuckDNS Subdomains as an environment variable or secret'
    exit 1
  else
    if [ -f $SUBDOMAINS_FILE ]; then
      # echo 'subdomains in secret file'
      duck_subdomain="$(cat ${SUBDOMAINS_FILE})"
    else
      echo "Please check subdomains secret. Passed incorrectly."
      exit 1
    fi
  fi
else
  duck_subdomain=$SUBDOMAINS
fi

if [ -z $TOKEN ]; then
  if [ -z $TOKEN_FILE ]; then
    echo 'Please enter $DUCKDNS_TOKEN as an environment variable or secret'
    exit 1
  else
    if [ -f $TOKEN_FILE ]; then
      # echo 'token in secret file'
      duck_token="$(cat ${TOKEN_FILE})"
    else
      echo "Please check token secret. Passed incorrectly"
      exit 1
    fi
  fi
else
  duck_token=$TOKEN
fi

# curl "https://www.duckdns.org/update?domains=${duck_subdomain}&token=${duck_token}&ip="

info=$(echo url="https://www.duckdns.org/update?domains=${duck_subdomain}&token=${duck_token}&ip=" | curl -s -k -K - )

if [ "$info" == "OK" ]; then
  echo "[$(date)] DuckDNS update ok"
else
  echo "[$(date)] DuckDNS update failed"
fi
