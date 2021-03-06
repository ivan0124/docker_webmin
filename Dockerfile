FROM ubuntu:16.04
#MAINTAINER Advantech

# Change root password
RUN echo root:pass | chpasswd
RUN apt-get -o Acquire::GzipIndexes=false update
#RUN echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes
# Add some package
RUN apt-get update && apt-get install -y wget locales nano ntpdate
# Add locale
RUN locale-gen en_US.UTF-8 && locale-gen th_TH.UTF-8 && dpkg-reconfigure locales
# Add webmin repository key
RUN wget http://www.webmin.com/jcameron-key.asc && apt-key add jcameron-key.asc
# Add webmin repository
RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list.d/webmin.list
#RUN echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
#RUN echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
# Update OS
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get purge apt-show-versions
#RUN rm /var/lib/apt/lists/*gz
#RUN apt-get -o Acquire::GzipIndexes=false update
RUN apt-get install -y apt-show-versions
RUN apt-get install -y apt-transport-https
RUN apt-get install -y sudo git
# Install webmin
RUN apt-get install -y webmin && apt-get autoclean

##
###RUN git clone https://github.com/ADVANTECH-Corp/APIGateway.git /home/adv/api_gw
##
#RUN rm -rf /usr/share/webmin/advan_wsn_setting
#RUN mkdir -p /usr/share/webmin/advan_wsn_setting
#RUN chmod a+rwx -R /usr/share/webmin/advan_wsn_setting
#RUN chmod a+rw /etc/webmin/webmin.acl
RUN echo "root: advan_wsn_setting" >> /etc/webmin/webmin.acl
#RUN cp -Rf /home/adv/api_gw/apps/wsn_manage/wsn_setting/* /usr/share/webmin/advan_wsn_setting/
###RUN chmod a+rwx -R /usr/share/webmin/
###RUN chmod a+rwx /var/webmin/module.infos.cache

ENV LC_ALL en_US.UTF-8
#webmin use port 10000
EXPOSE 10000

#VOLUME ["/etc/webmin"]
VOLUME ["/usr/share/webmin/advan_wsn_setting"]

CMD /usr/bin/touch /var/webmin/miniserv.log && /usr/sbin/service webmin restart && /usr/bin/tail -f /var/webmin/miniserv.log

## adv account
#RUN useradd -m -k /home/adv adv -p adv -s /bin/bash -G sudo
## set up adv as sudo
#RUN echo "adv ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
#WORKDIR /home/adv
#USER adv
