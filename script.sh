#!/bin/bash

cd $(dirname $0)

#read setting file
sed -z -e "s/.*##\+web#*//g" \
	-e "s/##.\+//g" setting.txt >setting.log

cp -frp /home/podman/ssl_pod/letsencrypt .

#build image
read -p "do you want to up this container ? (y/n):" yn
if [ ${yn,,} = "y" ]; then
#	podman rmi -f nginx
	podman rmi -f php-fpm
#	podman rmi -f mariaDB
#	podman build -f Dockerfile-nginx -t nginx:latest
	podman build -f Dockerfile-php-fpm -t php-fpm:latest
#	podman build -f Dockerfile-mariaDB -t mariaDB:latest
fi
rm *.log
