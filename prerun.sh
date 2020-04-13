#!/usr/bin/bash

#/etc/nginx/nginx.conf
sed  -i -e "/http\ /a \ \ \ \ server_tokens off;" \
	-e "/keepalive/ s/65/5/" \
	-e "/include.*\.conf/a \ \ \ \ include\ \/etc\/nginx\/user_conf.d\/\*\.conf;" \
	-e "s/#gzip/gzip/" /etc/nginx/nginx.conf

mkdir /etc/nginx/default_conf.d
cp /etc/nginx/conf.d/default.conf /etc/nginx/default_conf.d/default.conf.old

#/etc/rsyslog.conf
sed -i -e "/imjournal/ s/^/#/" \
	-e "s/off/on/" /etc/rsyslog.conf

#start webserver program
echo """
#set default config file
cp /etc/nginx/default_conf.d/default.conf.old /etc/nginx/user_conf.d/default.conf.old
#start web program
/usr/sbin/rsyslogd

/usr/sbin/nginx -c /etc/nginx/nginx.conf

php-fpm

tail -f /dev/null """>>/usr/local/bin/run.sh
