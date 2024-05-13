FROM centos:latest
ENV container docker


MAINTAINER gajendranv@gmil.com
LABEL Vendor="Thoughtworks Home Assignment"
LABEL Version=1.0.0

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y update && yum clean all
RUN yum -y install --setopt=tsflags=nodocs epel-release

#RUN dnf install bind-utils pwgen psmisc hostname
RUN yum install -y mariadb-server mariadb

RUN useradd -ms /bin/bash gaja
WORKDIR /home/gaja

COPY sql/createdb.sql /home/gaja

COPY bin/start-mariadb.sh /home/gaja/start-mariadb.sh
RUN chmod +x /home/gaja/start-mariadb.sh
RUN ./start-mariadb.sh

COPY bin/executeSQL.sh /home/gaja
RUN chmod +x /home/gaja/executeSQL.sh
#RUN /home/gaja/executeSQL.sh

COPY bin/stop-mariadb.sh /home/gaja/stop-mariadb.sh
#RUN chmod +x /home/gaja/stop-mariadb.sh

#COPY conf/my.cnf /etc/my.cnf


EXPOSE 3306

#ENTRYPOINT ["/home/gaja/start-mariadb.sh"]