#!/usr/bin/bash

#start rsyslog
rsyslogd

if [ ! -e /etc/nginx/user_conf.d/default.conf.old ]; then
	cp -frp /etc/nginx/default_conf.d/default.conf.old /etc/nginx/user_conf.d/default.conf.old && \
	cp -frp /etc/nginx/default_conf.d/html /usr/share/nginx/html && \
	echo $(date)>>/var/log/copy_default.log && \
	echo "Copy /etc/nginx/default_conf.d/default.conf.old from /etc/nginx/user_conf.d/default.conf.old ">>/var/log/copy_default.log && \
	echo >>/var/log/copy_default.log
fi

chown -R nginx:nginx /etc/nginx/user_conf.d
chown -R nginx:nginx /usr/share/nginx

#start nginx
nginx -c /etc/nginx/nginx.conf

mkdir -p /run/php-fpm/

#start FastCGI
php-fpm

tail -f /dev/null
