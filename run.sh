#!/usr/bin/bash

rsyslogd
mysqld --user=mysql &

if [ -e /usr/bin/mysql_secure_installation.old ]; then
	mysql_secure_installation && \
		rm /usr/bin/mysql_secure_installation && \
		mv /usr/bin/mysql_secure_installation.old /usr/bin/mysql_secure_installation
	echo $(date)>>/var/log/mysql_secure_installation.log
	echo "mysql_secure_installation done!!">>/var/log/mysql_secure_installation.log
	echo >>/var/log/mysql_secure_installation.log
fi

tail -f /dev/null
