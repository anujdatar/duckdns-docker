FROM alpine:latest

LABEL org.opencontainers.image.source="https://github.com/anujdatar/duckdns-docker"
LABEL org.opencontainers.image.description="DuckDNS IP Updater"
LABEL org.opencontainers.image.author="Anuj Datar <anuj.datar@gmail.com>"
LABEL org.opencontainers.image.url="https://github.com/anujdatar/duckdns-docker/blob/main/README.md"
LABEL org.opencontainers.image.licenses=MIT

# default env variables
ENV FREQUENCY 5

# install dependencies
RUN apk update && apk add --no-cache tzdata curl

# copy scripts over
COPY scripts /
RUN chmod 700 /container-setup.sh /ddns-update.sh /entry.sh

CMD ["/entry.sh"]
