#!/usr/bin/bash

#start rsyslog
rsyslogd

if [ ! -d /var/lib/mysql/mysql ]; then
	cp -frp /var/lib/mysql_default/* /var/lib/mysql && \
	rm -fr  /var/lib/mysql_default/ && \
	echo $(date)>>/var/log/mysql_secure_installation.log && \
	echo "Copy /var/lib/mysql from /var/lib/mysql_default" >>/var/log/mysql_secure_installation.log && \
	echo >>/var/log/mysql_secure_installation.log
fi

chown -R mysql:mysql /var/lib/mysql

#start MariaDB
mysqld --user=mysql &

if [ -e /usr/bin/mysql_secure_installation.old ]; then
	mysql_secure_installation && \
	rm -fr /usr/bin/mysql_secure_installation && \
	cp -frp /usr/bin/mysql_secure_installation.old /usr/bin/mysql_secure_installation && \
	echo $(date)>>/var/log/mysql_secure_installation.log && \
	echo "Run mysql_secure_installation">>/var/log/mysql_secure_installation.log && \
	echo >>/var/log/mysql_secure_installation.log
fi

tail -f /dev/null
