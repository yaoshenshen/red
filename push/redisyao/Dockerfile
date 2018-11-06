# RedCore base OS
#
FROM centos
#Commands
#
RUN rm -rf /etc/yum.repos.d/*
RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
RUN yum install -y net-tools 

#set system
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#
#

#Redis
COPY redis /project/redis


#
# External port 
EXPOSE 6379
#
#
# Command redis 
ENTRYPOINT [ "/project/redis/bin/redis-server","/project/redis/bin/redis.conf"]
#

