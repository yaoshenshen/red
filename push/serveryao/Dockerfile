# RedCore base OS
#
FROM centos
#Commands
#
RUN rm -rf /etc/yum.repos.d/*
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum install -y net-tools && yum clean all
#

#set system
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#JAVA
RUN mkdir -p /project
COPY jdk1.8.0_131 /usr/jdk 
ENV JAVA_HOME=/usr/jdk
ENV CLASSPATH=$JAVA_HOME/lib/
ENV PATH=$PATH:$JAVA_HOME/bin
ENV PUSH_SERVER_LOG_LEVEL=INFO
ENV PUSH_SERVER=/project/server
ENV export PATH JAVA_HOME CLASSPATH PUSH_SERVER_LOG_LEVEL PUSH_SERVER

ENV Xms=1600m \
    Xmx=1600m

# External port 
EXPOSE 8080 
#
WORKDIR /project/server
# Command ip 
ENTRYPOINT ["/project/server/sed.sh"]
CMD ["java","-jar","Redcore_PushService-1.0.0-boot.jar"]


