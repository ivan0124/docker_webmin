FROM ubuntu:16.04
#MAINTAINER Advantech

# Change root password
RUN echo root:pass | chpasswd
# Add some package
RUN apt-get update
RUN apt-get install -y wget
#
RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
RUN echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
#
RUN cd /root
RUN wget http://www.webmin.com/jcameron-key.asc
RUN apt-key add jcameron-key.asc
#
RUN apt-get install -y webmin
RUN ufw allow 10000

EXPOSE 10000
