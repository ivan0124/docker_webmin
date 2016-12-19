FROM ubuntu:16.04
#MAINTAINER Advantech

# Change root password
RUN echo root:pass | chpasswd
RUN echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes
# Add some package
RUN apt-get update && apt-get install -y wget locales nano ntpdate
# Add locale
RUN locale-gen en_US.UTF-8 && locale-gen th_TH.UTF-8 && dpkg-reconfigure locales
# Add webmin repository key
RUN wget http://www.webmin.com/jcameron-key.asc && apt-key add jcameron-key.asc
# Add webmin repository
RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list.d/webmin.list
# Update OS
RUN apt-get update && apt-get dist-upgrade -y
# Install webmin and clean file
RUN apt-get install -y webmin && apt-get autoclean


ENV LC_ALL en_US.UTF-8

EXPOSE 10000

VOLUME ["/etc/webmin"]

#CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log
CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/bin/tail -f /var/webmin/miniserv.log

# adv account
RUN useradd -m -k /home/adv adv -p adv -s /bin/bash -G sudo

# set up adv as sudo
RUN echo "adv ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/adv
USER adv
