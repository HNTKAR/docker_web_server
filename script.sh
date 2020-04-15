#!/bin/bash

#version test
version_code="1"
setting_file_version=$(sed -e "s/^##.*//g"  -e "/^$/d" setting.txt|grep version|head -n 1|sed s/.*://)
if [ "x$setting_file_version" != "x$version_code" ];then
        echo "setting.txt version error"
        exit 1;
fi;

#read setting file
sed -e "s/^##.*//g"  setting.txt |\
       	sed -ze "s/.*=====general=====//g" \
	-e  "s/=====.*//g" |\
	sed -e /^$/d>general.log

sed -e "s/^##.*//g"  setting.txt |\
	sed -ze "s/.*=====database=====//g" \
	-e  "s/=====.*//g" |\
	sed -ze "s/.*-----system data-----//g" \
	-e "s/-----.*//g" |\
	sed -e /^$/d>database-system.log

sed -e "s/^##.*//g"  setting.txt |\
	sed -ze "s/.*=====database=====//g" \
	-e  "s/=====.*//g" |\
	sed -ze "s/.*-----user data-----//g" \
	-e "s/-----.*//g" |\
	sed -e /^$/d>database-user.log

mkdir -m 777 -p  /home/docker_home/

#set docker-compose.yml
sed -i -e "/root_password/ s/:.*/:\ $(grep root_password database-system.log | sed s/.*://)/" docker-compose.yml

rm *.log
read -p "do you want to up this container ? (y/n):" yn
if [ ${yn,,} = "y" ]; then
	docker-compose up --build -d
fi
