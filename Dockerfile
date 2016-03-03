From centos
MAINTAINER sahsu.mobi@gmail.com
ENV OPSMANAGER_VERSION=2.0.2.337-1 \
    OPSMANAGERBACKUP_VERSION=1.8.2.312-1 \
    OPSMANAGER_CFG=/opt/mongodb/mms/conf/conf-mms.properties \
    OPSMANAGER_BACKUPCFG=/opt/mongodb/mms-backup-daemon/conf/conf-daemon.properties \
    OPSMANAGER_MONGO_APP=localhost:27017 \
    OPSMANAGER_CENTRALURL=localhost \
    OPSMANAGER_CENTRALURLPORT=8080 \
    OPSMANAGER_BACKUPURL=${OPSMANAGER_CENTRALURL} \
    OPSMANAGER_BACKUPURLPORT=8081 \
    OPSMANAGER_FROMEMAIL=nobody@nobody \
    OPSMANAGER_ADMINEMAIL=nobody@nobody \
    OPSMANAGER_REPLYTOEMAIL=nobody@nobody \
    OPSMANAGER_ADMINFROMEMAIL=nbody@nobody \
    OPSMANAGER_BOUNCEEMAIL=nobody@nobody \
    OPSMANAGER_APPLOG=/opt/mongodb/mms/logs \
    OPSMANAGER_BACKUPLOG=/opt/mongodb/mms-backup-daemon/logs \
    OPSMANAGER_BACKUPMONGO=localhost:27017 \
    OPSMANAGER_BACKUPPATH=/backup/ 
#    OPSMANAGER_BACKUPSUPPORTVERSION=3.0.6 2.6.11 

# download url: https://www.mongodb.com/subscription/downloads/ops-manager
# sample Ops manager download url: 
# https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-1.8.1.290-1.x86_64.rpm
# https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-2.0.2.337-1.x86_64.rpm
# backup : https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-backup-daemon-1.8.1.290-1.x86_64.rpm


# INSTALL MMS & MMS-BACKUP
RUN  curl -OL https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-${OPSMANAGER_VERSION}.x86_64.rpm \
    && rpm -ivh mongodb-mms-${OPSMANAGER_VERSION}.x86_64.rpm && rm -f mongodb-mms-${OPSMANAGER_VERSION}.x86_64.rpm \
    && curl -OL https://downloads.mongodb.com/on-prem-mms/rpm/mongodb-mms-backup-daemon-${OPSMANAGERBACKUP_VERSION}.x86_64.rpm \
    && rpm -ivh mongodb-mms-backup-daemon-${OPSMANAGERBACKUP_VERSION}.x86_64.rpm && rm -f mongodb-mms-backup-daemon-${OPSMANAGERBACKUP_VERSION}.x86_64.rpm \
    && cd /opt/mongodb/ && rm -fr mms-backup-daemon/jdk && cd mms-backup-daemon && ln -s ../mms/jdk . \
    && cd /opt/mongodb && rm -fr mms-backup-daemon/lib && cd mms-backup-daemon && ln -s ../mms/lib . 

RUN echo '[10gen] ' >> /etc/yum.repos.d/10gen.repo && \
echo 'name=10gen Repository' >> /etc/yum.repos.d/10gen.repo && \
echo 'baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64' >> /etc/yum.repos.d/10gen.repo && \
echo 'gpgcheck=0' >> /etc/yum.repos.d/10gen.repo && \
echo 'enabled=1'  >> /etc/yum.repos.d/10gen.repo && \
yum install -y mongodb-org-server mongodb-org-shell && yum clean all

# INSTALL few related package
RUN yum install -y python-setuptools \
                sudo \
                dstat \
                nmap \
                telnet \
                openssl \
                net-tools \
                postfix \
    && easy_install supervisor \
    && yum clean all \
    && cat /etc/sudoers| grep -ivE requiretty > /tmp/sudoers && mv /tmp/sudoers /etc/sudoers \
    && ln -s /opt/mongodb/mms/logs /root/logs \
    && ln -s /opt/mongodb/mms-backup-daemon/logs /root/blogs  \
    && ln -s /data/appdb/mongodb.log /root/applog \
    && ln -s /data/backupdb/mongodb.log /root/backuplog \
    && rpm -ivh http://pkgs.repoforge.org/htop/htop-0.8.3-1.el6.rf.x86_64.rpm && yum clean all

EXPOSE ${OPSMANAGER_CENTRALURLPORT}/tcp ${OPSMANAGER_BACKUPURLPORT}/tcp
VOLUME [${OPSMANAGER_APPLOG}, ${OPSMANAGER_BACKUPLOG}]

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
COPY startup.sh /startup.sh
RUN chmod 755 startup.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]

