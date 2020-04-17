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
	sed -ze "s/.*=====webserver=====//g" \
	-e  "s/=====.*//g" | \
	sed -ze "s/.*-----system data-----//g" \
	-e "s/-----.*//g" | \
	sed -e /^$/d>system.log

sed -e "s/^##.*//g"  setting.txt | \
	sed -ze "s/.*=====webserver=====//g" \
	-e  "s/=====.*//g" | \
	sed -ze "s/.*-----user data-----//g" \
	-e "s/-----.*//g" | \
	sed -e /^$/d>user.log

#host setting
mkdir -m 777 -p  /home/docker_home/
mkdir -p /var/log/docker_log/webserver/nginx/
mkdir -p /var/log/docker_log/webserver/php-fpm/

read -p "do you want to up this container ? (y/n):" yn
if [ ${yn,,} = "y" ]; then
	docker-compose up --build -d
	rm -fr remove_firewall.sh

	firewall_opt=$(grep firewall_block system.log | sed -e "s/.*://")
	if [ x${firewall_opt,,} = "xon" ]; then
		firewall-cmd --direct --add-chain ipv4 filter DOCKER-USER-WEB && \
		firewall-cmd --direct --add-rule ipv4 filter DOCKER-USER 1 -j DOCKER-USER-WEB && \
		firewall-cmd --direct --add-rule ipv4 filter DOCKER-USER-WEB 99 -p tcp --dport 80 -j DROP && \
		firewall-cmd --direct --add-rule ipv4 filter DOCKER-USER-WEB 99 -p tcp --dport 443 -j DROP && \
		grep access_ip system.log | \
			sed -e "s/.*://" | \
			xargs -I {} firewall-cmd --direct --add-rule ipv4 filter DOCKER-USER-WEB 1 -s {} -p tcp --dport 80 -j ACCEPT && \
		grep access_ip system.log | \
			sed -e "s/.*://" | \
			xargs -I {} firewall-cmd --direct --add-rule ipv4 filter DOCKER-USER-WEB 1 -s {} -p tcp --dport 443 -j ACCEPT && \
		grep access_ip system.log | \
			sed -e "s/.*://" | \
			xargs -I {} echo "firewall-cmd --direct --remove-rule ipv4 filter DOCKER-USER-WEB 1 -s {} -p tcp --dport 80 -j ACCEPT">>remove_firewall.sh && \
		grep access_ip system.log | \
			sed -e "s/.*://" | \
			xargs -I {} echo "firewall-cmd --direct --remove-rule ipv4 filter DOCKER-USER-WEB 1 -s {} -p tcp --dport 443 -j ACCEPT">>remove_firewall.sh && \
		echo "firewall-cmd --direct --remove-rule ipv4 filter DOCKER-USER-WEB 99 -p tcp --dport 80 -j DROP">>remove_firewall.sh && \
		echo "firewall-cmd --direct --remove-rule ipv4 filter DOCKER-USER-WEB 99 -p tcp --dport 443 -j DROP">>remove_firewall.sh && \
		echo "firewall-cmd --direct --remove-rule ipv4 filter DOCKER-USER 1 -j DOCKER-USER-WEB">>remove_firewall.sh && \
		echo "firewall-cmd --direct --remove-chain ipv4 filter DOCKER-USER-WEB">>remove_firewall.sh && \
		chmod 775 remove_firewall.sh
	fi
fi
rm *.log
