FROM centos
MAINTAINER kusari-k

EXPOSE 80

RUN yum update -y
RUN echo -e """[nginx-stable] \n\
name=nginx stable repo \n\
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/ \n\
gpgcheck=1 \n\
enabled=1 \n\
gpgkey=https://nginx.org/keys/nginx_signing.key \n\
module_hotfixes=true \n\
[nginx-mainline] \n\
name=nginx mainline repo \n\
baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/ \n\
gpgcheck=1 \n\
enabled=0 \n\
gpgkey=https://nginx.org/keys/nginx_signing.key \n\
module_hotfixes=true""">/etc/yum.repos.d/nginx.repo

RUN yum install -y nginx
RUN yum clean all

COPY run.sh  /usr/local/bin/
RUN  chmod 755 /usr/local/bin/run.sh

ENTRYPOINT ["/usr/local/bin/run.sh"]
