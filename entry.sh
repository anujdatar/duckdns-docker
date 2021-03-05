#!/bin/sh

# add duck start script to crontab
echo "*/${FREQUENCY} * * * * /duck.sh" > /crontab.txt
/usr/bin/crontab /crontab.txt


# start cron
/usr/sbin/crond -f -l 8