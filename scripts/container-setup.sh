#!/bin/sh

print_breaker() {
  echo "-------------------------------------------------"
}

# #####################################################################
# Step 1: set up timezone
if [ -z "$TZ" ]; then
  echo "TZ environment variable not set. Using default: UTC"
else
  echo "Setting timezone to $TZ"
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ > /etc/timezone
fi

echo "Starting DuckDNS container: [$(date)]"
print_breaker
# #####################################################################
# Step 2: Check API Key
if [ -f "$TOKEN_FILE" ]; then
  TOKEN=$(cat "$TOKEN_FILE")
fi
if [ -z "$TOKEN" ]; then
  echo "Please enter a valid TOKEN env variable or TOKEN_FILE secret"
  exit 1
fi
echo "DuckDNS Token  ---  OK"
# #####################################################################
# Step 3: Check Subdomains
if [ -f "$SUBDOMAINS_FILE" ]; then
  SUBDOMAINS=$(cat "$SUBDOMAINS_FILE")
fi
if [ -z "$SUBDOMAINS" ]; then
  echo "Please enter a valid SUBDOMAINS env variable or SUBDOMAINS_FILE secret"
  exit 1
fi
echo "DuckDNS Subdomains  ---  OK"
# #####################################################################
# Step 4: Save to config file
print_breaker
echo "TOKEN=\"$TOKEN\"" > /config.sh
echo "SUBDOMAINS=\"$SUBDOMAINS\"" >> /config.sh
# #####################################################################
echo "DuckDNS container setup complete"
print_breaker
print_breaker
