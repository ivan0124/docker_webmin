FROM ubuntu:16.04
#MAINTAINER Advantech

# Change root password
RUN echo root:pass | chpasswd
#RUN echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes
# Add some package
RUN apt-get update && apt-get install -y wget locales nano ntpdate
# Add locale
#RUN locale-gen en_US.UTF-8 && locale-gen th_TH.UTF-8 && dpkg-reconfigure locales
# Add webmin repository
RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
RUN echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
# Add webmin repository key
RUN cd /root
RUN wget http://www.webmin.com/jcameron-key.asc && apt-key add jcameron-key.asc
# Update OS
RUN apt-get update
RUN apt-get install -y apt-transport-https
RUN apt-get install apt-show-versions
# Install webmin
RUN apt-get install -y webmin


#ENV LC_ALL en_US.UTF-8

EXPOSE 10000

#VOLUME ["/etc/webmin"]

#CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log
