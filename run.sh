#!/usr/bin/bash

rsyslogd

chown -R mysql:mysql /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
	cp -frp /var/lib/mysql_default/* /var/lib/mysql && \
	echo $(date)>>/var/log/mysql_secure_installation.log && \
	echo "Copy /var/lib/mysql from /var/lib/mysql_default" && \
	rm -fr  /var/lib/mysql_default/
fi

mysqld --user=mysql &

if [ -e /usr/bin/mysql_secure_installation.old ]; then
	mysql_secure_installation && \
	rm /usr/bin/mysql_secure_installation && \
	mv /usr/bin/mysql_secure_installation.old /usr/bin/mysql_secure_installation && \
	echo $(date)>>/var/log/mysql_secure_installation.log && \
	echo "mysql_secure_installation done!!">>/var/log/mysql_secure_installation.log && \
	echo >>/var/log/mysql_secure_installation.log
fi

tail -f /dev/null
