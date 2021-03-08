# DuckDNS Docker

Update IP on DuckDNS periodically, with minimal dependencies.

Uses Alpine Linux for a minimal footprint. Uses a cronjob to run the standard DuckDNS curl script using no external dependencies.

Also works with docker secrets.
Tested on `amd64` and `aarm64`

---

## Parameters / Environment Variables
| # | Parameter | Default | Notes | Description |
| - | ---------- | ----- | -- | --- |
| 1 | FREQUENCY | 5 | OPTIONAL | how often you want to update IP on DuckDNS (default = every 5 minutes) |
| 2 | SUBDOMAINS | - | REQUIRED | your registered DuckDNS subdomains. Multiple comma separated subdomains allowed, no spaces. |
| 3 | TOKEN | - | REQUIRED | DuckDNS token |

---

## Usage
### Docker cli
```bash
docker run -d \
  -e SUBDOMAINS=<your-comma-separated-subdomains> \
  -e TOKEN=<your-duckdns-token> \
  --restart unless-stopped \
  --name duckdns \
  duckdns
```

### docker-compose
```yml
version: "3"
services:
  testduckdns:
    image: duckdns
    container_name: duckdns
    restart: unless-stopped
    environment:
      - SUBDOMAINS=<your-comma-separated-subdomains>
      - TOKEN=<your-duckdns-token>
      - FREQUENCY=1  # OPTIONAL, default is 5
```

### using docker-compose and docker secrets
In case you plan to commit your docker-compose files to repos and wish to keep tokens/domains secure
```yml
version: "3"
services:
  testduckdns:
    image: duckdns
    container_name: duckdns
    restart: unless-stopped
    environment:
      - SUBDOMAINS_FILE=/run/secrets/duckdns_subdomains
      - TOKEN_FILE=/run/secrets/duckdns_token
      - FREQUENCY=1  # OPTIONAL, default is 5
    secrets:
      - duckdns_subdomains
      - duckdns_token

secrets:
  duckdns_subdomains:
    file: duckdns_subdomains.txt
  duckdns_token:
    file: duckdns_token.txt
```

Your secret files should just be plain text strings containing subdomains/tokens

#### duckdns_subdomains.txt
```txt
subdomain1,subdomain2
```
### duckdns_token.txt
```txt
your_duckdns_token
```
---

## Building
```
docker build -t duckdns .
```
