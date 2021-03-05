FROM alpine:latest

# default env variables
ENV FREQUENCY 5

ADD duck.sh /duck.sh
ADD entry.sh /entry.sh

RUN apk --no-cache add curl
RUN chmod 700 /duck.sh /entry.sh

CMD ["/entry.sh"]
