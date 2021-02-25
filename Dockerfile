FROM alpine:3.12

ADD crontab.txt /crontab.txt
ADD duck.sh /duck.sh
COPY entry.sh /entry.sh

RUN chmod 755 /duck.sh /entry.sh

RUN /usr/bin/crontab /crontab.txt

CMD ["/entry.sh"]
