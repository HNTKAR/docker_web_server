#!/usr/bin/bash

mkdir -p -m 755 /log /nginx_conf/conf.d /log/php-fpm/ /run/php-fpm/

if [ ! -e /nginx_conf/conf.d/php-fpm.conf ];then
	cp -frp /etc/nginx/conf.d/php-fpm.conf /nginx_conf/conf.d/php-fpm.conf
fi

if [ ! -e /nginx_conf/conf.d/php.conf ];then
	cp -frp /etc/nginx/default.d/php.conf /nginx_conf/conf.d/php.conf
fi

#start rsyslog
rsyslogd

#start FastCGI
php-fpm
tail -f /dev/null
