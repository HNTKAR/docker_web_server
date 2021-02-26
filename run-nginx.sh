#!/usr/bin/bash

mkdir -p -m 755 /log/nginx/

if [ ! -e /conf/nginx.conf ];then
	cp -frp /etc/nginx/* /conf
fi

rm /usr/local/bin/setting.log
#chown -R nginx:nginx /etc/nginx/user_conf.d
#chown -R nginx:nginx /usr/share/nginx

#start rsyslog
rsyslogd

#start nginx
nginx -c /conf/nginx.conf
tail -f /dev/null
