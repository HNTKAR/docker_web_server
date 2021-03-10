#!/usr/bin/bash

mkdir -p -m 755 /conf/etc /conf/usr /log /log/nginx/

if [ ! -e /conf/nginx.conf ];then
	cp -frp /etc/nginx/* /conf/etc
	cp -frp /usr/share/nginx/* /conf/usr
fi

rm /usr/local/bin/setting.log

#start rsyslog
rsyslogd

#start nginx
nginx -c /conf/etc/nginx.conf
tail -f /dev/null
