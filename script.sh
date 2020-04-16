#!/bin/bash

#version test
version_code="1"
setting_file_version=$(sed -e "s/^##.*//g"  -e "/^$/d" setting.txt|grep version|head -n 1|sed s/.*://)
if [ "x$setting_file_version" != "x$version_code" ];then
        echo "setting.txt version error"
        exit 1;
fi;

cd $(dirname $0)

#read setting file
sed -e "s/^##.*//g"  setting.txt |\
       	sed -ze "s/.*=====general=====//g" \
	-e  "s/=====.*//g" |\
	sed -e /^$/d>general.log

sed -e "s/^##.*//g"  setting.txt |\
	sed -ze "s/.*=====webserver=====//g" \
	-e  "s/=====.*//g" |\
	sed -ze "s/.*-----system data-----//g" \
	-e "s/-----.*//g" |\
	sed -e /^$/d>webserver-system.log

sed -e "s/^##.*//g"  setting.txt |\
	sed -ze "s/.*=====webserver=====//g" \
	-e  "s/=====.*//g" |\
	sed -ze "s/.*-----user data-----//g" \
	-e "s/-----.*//g" |\
	sed -e /^$/d>webserver-user.log

#host setting
mkdir -m 777 -p  /home/docker_home/
mkdir -p /var/log/docker_log/webserver/nginx/
mkdir -p /var/log/docker_log/webserver/php-fpm/
rm *.log

read -p "do you want to up this container ? (y/n):" yn
if [ ${yn,,} = "y" ]; then
	docker-compose up --build -d
fi
