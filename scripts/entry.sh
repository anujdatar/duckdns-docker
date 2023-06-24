#!/bin/sh

. /container-setup.sh
. /ddns-update.sh

# add duck start script to crontab
echo "*/${FREQUENCY} * * * * /ddns-update.sh" > /crontab.txt
/usr/bin/crontab /crontab.txt


# start cron
/usr/sbin/crond -f -l 8
