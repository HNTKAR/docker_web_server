#!/usr/bin/bash


mkdir -p -m 755 /data /conf /log

#start rsyslog
rsyslogd

#if [ ! -d /var/lib/mysql/mysql ]; then
#	cp -frp /var/lib/mysql_default/* /var/lib/mysql && \
#	rm -fr  /var/lib/mysql_default/ && \
#	echo $(date)>>/var/log/mysql_secure_installation.log && \
#	echo "Copy /var/lib/mysql from /var/lib/mysql_default" >>/var/log/mysql_secure_installation.log && \
#	echo >>/var/log/mysql_secure_installation.log
#fi

#chown -R mysql:mysql /var/lib/mysql

#start rsyslog
rsyslogd

#start MariaDB
mysqld --user=mysql

if [ /usr/local/bin/setting.log ]; then
	mysqladmin -u root password $S_pass
	mysqladmin -p -u root localhost password $S_pass
#	mysql_secure_installation && \
#	rm -fr /usr/bin/mysql_secure_installation && \
#	cp -frp /usr/bin/mysql_secure_installation.old /usr/bin/mysql_secure_installation && \
#	echo $(date)>>/var/log/mysql_secure_installation.log && \
#	echo "Run mysql_secure_installation">>/var/log/mysql_secure_installation.log && \
#	echo >>/var/log/mysql_secure_installation.log
fi

unset S_pass

rm /usr/local/bin/setting.log

tail -f /dev/null
