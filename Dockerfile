FROM centos
MAINTAINER kusari-k

EXPOSE 80

RUN dnf update -y
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
enabled=1 \n\
gpgkey=https://nginx.org/keys/nginx_signing.key \n\
module_hotfixes=true""">/etc/yum.repos.d/nginx.repo
RUN dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf install -y nginx rsyslog  @php:remi-7.3
RUN dnf clean all

COPY prerun.sh  /usr/local/bin/
RUN  chmod 755 /usr/local/bin/prerun.sh
COPY run.sh  /usr/local/bin/
RUN  chmod 755 /usr/local/bin/run.sh
RUN  /usr/local/bin/prerun.sh
ENTRYPOINT ["/usr/local/bin/run.sh"]
