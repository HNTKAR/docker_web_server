FROM centos
MAINTAINER kusari-k

ARG root_password="password"

RUN curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash && \
dnf update -y && \
dnf install -y rsyslog MariaDB passwd && \
dnf update -y && \
dnf clean all

#EXPOSE 25 995 993 465 587

COPY run.sh  /usr/local/bin/

RUN  chmod 755 /usr/local/bin/run.sh

RUN sed -i.old -e "/read\ / s/.*/echo/ " \
	-e "/trap/a password1=$root_password" \
	-e "/trap/a password2=$root_password" /usr/bin/mysql_secure_installation

#RUN mysql_secure_installation && \
#	rm /usr/bin/mysql_secure_installation && \
#	mv /usr/bin/mysql_secure_installation.old /usr/bin/mysql_secure_installation

ENTRYPOINT ["/usr/local/bin/run.sh"]
