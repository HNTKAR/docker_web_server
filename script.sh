#!/bin/bash

cd $(dirname $0)

#read setting file
sed -z -e "s/.*##\+web#*//g" \
	-e "s/##.\+//g" setting.txt >setting.log
export web_DOMAIN=$(grep ^web_domain setting.log|sed "s/.*://")
export SSL_DOMAIN=$(grep ^ssl_domain setting.log|sed "s/.*://")

cp -frp /home/podman/ssl_pod/letsencrypt .

#build image
read -p "do you want to up this container ? (y/n):" yn
if [ ${yn,,} = "y" ]; then
	podman rmi -f nginx
	podman rmi -f mariadb
	podman build -f Dockerfile-nginx -t nginx:latest --build-arg WEB_DOMAIN=$WEB_DOMAIN --build-arg SSL_DOMAIN=$SSL_DOMAIN
fi
rm *.log
