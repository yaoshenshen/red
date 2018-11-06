# RedCore base OS
#
FROM centos
#Commands
#
RUN rm -rf /etc/yum.repos.d/*
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum install -y net-tools openssh-server python-setuptools.noarch gcc && yum clean all
#
# Configuring supervisor
#
RUN easy_install supervisor
RUN mkdir -p /etc/supervisor/conf.d && chmod 755 /etc/supervisor/conf.d
#
# Add file 
#
ADD supervisord.conf /etc/supervisor/


#JAVA
RUN mkdir -p /project
COPY jdk1.8.0_131 /usr/jdk 
ENV JAVA_HOME=/usr/jdk
ENV CLASSPATH=$JAVA_HOME/lib/
ENV PATH=$PATH:$JAVA_HOME/bin
ENV PUSH_SERVER_LOG_LEVEL=INFO
ENV PUSH_SERVER=/project/push-server/server
ENV export PATH JAVA_HOME CLASSPATH PUSH_SERVER_LOG_LEVEL PUSH_SERVER

#Redis
COPY redis /project/redis

#Server
COPY server /project/server
COPY sed.sh /project/server/sed.sh
RUN sh /project/server/sed.sh 




ADD app-supervisor.ini /etc/supervisor/conf.d/app-supervisor.ini
#
# External port 
EXPOSE 6379
#
#
# Command redis 
ENTRYPOINT [ "/project/redis/bin/redis-server","/project/redis/bin/redis.conf"]
ENTRYPOINT ["java","-jar","/project/server/Redcore_PushService-1.0.0-boot.jar"]
#

