#!/bin/sh
echo "copying odbc files"
ls /opt/odbc
cp /opt/odbc/* /etc/
indexer --config  /opt/sphinx/conf/sphinx.conf --rotate --all
rm -fr /etc/cron.d/*
cp /opt/cron/* /etc/cron.d/ 
chmod 0644 /etc/cron.d/*
CRONFILES=/etc/cron.d/*
for f in $CRONFILES
do
  echo "Processing $f file..."
  # take action on each file. $f store current file name
  crontab $f
done

touch /var/log/cron.log
service cron start
searchd --nodetach --config /opt/sphinx/conf/sphinx.conf