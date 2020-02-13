#!/bin/bash
mkdir -p  /var/log/docker_log/webserver/nginx
read -p "do you want to up this container ? (y/n):" yn
if [ ${yn,,} = "y" ]; then
	docker-compose up --build -d
fi
