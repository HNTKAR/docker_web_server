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
sed -e "s/^##.*//g"  setting.txt | \
       	sed -ze "s/.*=====general=====//g" \
	-e  "s/=====.*//g" | \
	sed -e /^$/d>general.log

sed -e "s/^##.*//g"  setting.txt | \
	sed -ze "s/.*=====database=====//g" \
	-e  "s/=====.*//g" | \
	sed -ze "s/.*-----system data-----//g" \
	-e "s/-----.*//g" | \
	sed -e /^$/d>system.log

sed -e "s/^##.*//g"  setting.txt | \
	sed -ze "s/.*=====database=====//g" \
	-e  "s/=====.*//g" | \
	sed -ze "s/.*-----user data-----//g" \
	-e "s/-----.*//g" | \
	sed -e /^$/d>user.log

#host setting
mkdir -m 777 -p  /home/docker_home/

#set docker-compose.yml
sed -i -e "/root_password/ s/:.*/:\ $(grep root_password system.log | sed s/.*://)/" docker-compose.yml

read -p "do you want to up this container ? (y/n):" yn
if [ ${yn,,} = "y" ]; then
	docker-compose up --build -d
	rm -fr remove_firewall.sh

	grep access_ip system.log | \
		sed -e "s/.*://" | \
		xargs -I {} \
		firewall-cmd --direct --add-rule ipv4 filter DOCKER-USER 1 ! -s {} -p tcp --dport 3306 -j DROP
	grep access_ip system.log | \
		sed -e "s/.*://" | \
		xargs -I {} \
		echo "firewall-cmd --direct --remove-rule ipv4 filter DOCKER-USER 1 ! -s {} -p tcp --dport 3306 -j DROP">>remove_firewall.sh && \
		chmod 775 remove_firewall.sh
fi
rm *.log
