#!/usr/bin/bash

#/etc/nginx/nginx.conf
sed  -i -e "/http\ /a \ \ \ \ server_tokens off;" \
	-e "/keepalive/ s/65/5/" \
	-e "/include.*\.conf/a \ \ \ \ include\ \/etc\/nginx\/user_conf.d\/\*\.conf;" \
	-e "s/#gzip/gzip/" /etc/nginx/nginx.conf

#/etc/php.ini
sed -i -e "/expose_php/ s/On/Off/" \
	-e "/post_max_size/ s/8/500/" \
	-e "/upload_max_filesize/ s/2/500/" \
	-e "/;date\.timezone/ s/=/=\ \"Asia\/Tokyo\"/" \
	-e "/;date\.timezone/ s/;//" \
	-e "/;mbstring\.language/ s/;//" \
	-e "/;mbstring\.internal_encoding/ s/=/=\ UTF-8/" \
	-e "/;mbstring\.internal_encoding/ s/;//" \
       	-e "/;mbstring\.http_input\ / s/=/=\ UTF-8/" \
       	-e "/;mbstring\.http_input\ / s/;//" \
       	-e "/;mbstring\.http_output\ / s/=/=\ pass/" \
       	-e "/;mbstring\.http_output\ / s/;//" \
	-e "/;mbstring\.encoding_translation/ s/Off/On/" \
	-e "/;mbstring\.encoding_translation/ s/;//" \
	-e "/;mbstring.detect_order/ s/;//" \
	-e "/;mbstring.substitute_character/ s/;//" /etc/php.ini

#/etc/php-fpm.d/www.conf
sed -i -e "/user\ =/ s/apache/nginx/" \
	-e "/group\ =/ s/apache/nginx/" \
	-e "/max_children/ s/50/25/" \
	-e "/start_servers/ s/5/10/ "\
	-e "/min_spare_servers/ s/5/10/" \
	-e "/max_spare_servers/ s/35/20/" \
	-e "/max_requests/ s/;//" /etc/php-fpm.d/www.conf

mkdir /etc/nginx/default_conf.d
cp /etc/nginx/conf.d/default.conf /etc/nginx/default_conf.d/default.conf.old
cp -r /usr/share/nginx/html /etc/nginx/default_conf.d/

#/etc/rsyslog.conf
sed -i -e "/imjournal/ s/^/#/" \
	-e "s/off/on/" /etc/rsyslog.conf

#start webserver program
echo """
#set default config file
cp /etc/nginx/default_conf.d/default.conf.old /etc/nginx/user_conf.d/default.conf.old
cp -r /etc/nginx/default_conf.d/html /usr/share/nginx/html
chown -R nginx:nginx /etc/nginx/user_conf.d
chown -R nginx:nginx /usr/share/nginx/html

#start web program
rsyslogd

nginx -c /etc/nginx/nginx.conf

php-fpm

tail -f /dev/null """>>/usr/local/bin/run.sh
