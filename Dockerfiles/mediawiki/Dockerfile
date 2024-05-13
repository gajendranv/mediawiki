FROM centos:7
ENV container docker


MAINTAINER gajendranv@gmil.com
LABEL Vendor="Thoughtworks Home Assignment"
LABEL Version=1.0.0

#RUN cd /etc/yum.repos.d/
#RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
#RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

#RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
#RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


#RUN yum -y update && yum clean all
#RUN yum -y install --setopt=tsflags=nodocs epel-release
SHELL ["/usr/bin/env", "bash", "-c"]
RUN \
    yum install -y centos-release-scl && \
    yum install -y rh-python38-python-devel
ENV \
    BASH_ENV="/usr/bin/scl_enable" \
    ENV="/usr/bin/scl_enable" \
    PROMPT_COMMAND=". /usr/bin/scl_enable"
RUN echo -e "\n\
unset BASH_ENV PROMPT_COMMAND ENV\n\
source scl_source enable rh-python38\n\
" > /usr/bin/scl_enable
RUN yum -y install wget

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install anything. The service you want to start must be a SystemD service.

CMD ["/usr/sbin/init"]

#Install PHP Version
#RUN yum install -y rh-php73 rh-php73-php rh-php73-php-mbstring rh-php73-php-mysqlnd rh-php73-php-gd rh-php73-php-xml

#upgrade php-7.4.33 for mediawiki
RUN yum install -y epel-release
#RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum install -y yum-utils
#RUN yum-config-manager --enable remi-php74
RUN yum-config-manager --disable 'remi-php*'
RUN yum-config-manager --enable remi-php74
RUN yum update -y 
RUN yum install -y php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-process php-ldap php-fpm php-mbstring php-xml php-intl
yum install -y plesk-php80-dev make gcc
RUN yum install -y httpd

RUN useradd -ms /bin/bash gaja
WORKDIR /home/gaja

#RUN firewall-cmd --permanent --add-service=http
#RUN firewall-cmd --reload

RUN wget https://releases.wikimedia.org/mediawiki/1.40/mediawiki-1.40.2.tar.gz
RUN wget https://releases.wikimedia.org/mediawiki/1.40/mediawiki-1.40.2.tar.gz.sig
#RUN gpg --verify mediawiki-1.40.2.tar.gz.sig mediawiki-1.40.2.tar.gz

RUN tar -zxf /home/gaja/mediawiki-1.40.2.tar.gz --directory /var/www/html/
RUN ln -s /var/www/html/mediawiki-1.40.2/ /var/www/html/mediawiki

COPY conf/phpinfo.php /var/www/html
RUN chown -R apache:apache /var/www/html/mediawiki-1.40.2
RUN chown -R apache:apache /var/www/html/mediawiki

#CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
#RUN systemctl enable httpd24-httpd.service
#RUN systemctl restart httpd24-httpd.service

RUN systemctl restart httpd

#RUN service httpd restart

EXPOSE 80