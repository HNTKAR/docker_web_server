FROM centos
MAINTAINER kusari-k

EXPOSE 3306
ARG root_password="password"

RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
RUN sed -i -e "\$afastestmirror=true" /etc/dnf/dnf.conf
RUN dnf update -y && \
	dnf install -y rsyslog MariaDB && \
	dnf clean all

#/usr/bin/mysql_secure_installation
RUN sed -i.old -e "/read\ / s/.*/echo/ " \
	-e "/trap/a password1=$root_password" \
	-e "/trap/a password2=$root_password" /usr/bin/mysql_secure_installation

#/etc/rsyslog.conf
RUN sed -i -e "/imjournal/ s/^/#/" \
	-e "s/off/on/" /etc/rsyslog.conf

RUN cp -frp /var/lib/mysql /var/lib/mysql_default

COPY run.sh  /usr/local/bin/
RUN  chmod 755 /usr/local/bin/run.sh

ENTRYPOINT ["/usr/local/bin/run.sh"]
