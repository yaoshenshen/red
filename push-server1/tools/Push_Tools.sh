#!/bin/env bash
#
##############################################################
# Author sam <changwei.wen@redcore.cn>                       #
# Manager push_server - start stop restart                   #
#                                                            #
# Date: 2018/7/19                                            #
#                                                            #
# System: CentOS 7                                           #
#                                                            #
##############################################################
# Development environment CentOS 7                           #
##############################################################
# Para,eters for Script
#
SERVICE="PushService"                   # Manager service
#
# Service home_dir
#
SERVICE_HOME=/project/push-server/server
#
# Service pid number
#
SERVICE_PID=$(ps axu|grep "$SERVICE"|grep -v "grep"|awk '{print $2}')
#
server_start(){
cd $SERVICE_HOME
if [ ! $SERVICE_PID ]
then
    echo "################################################"
    echo "#             Push Server Staring             #"
    echo "################################################"
    echo "#              Wait .... ~~~!!!!!!!!!!!!!      #"
    echo "################################################"
    nohup java -Xms2048m -Xmx2048m -jar Redcore_PushService-1.0.0-boot.jar > /dev/null 2>&1 &
else
    echo "The service is running!!"
fi
}
#
server_stop(){
if [ ! $SERVICE_PID ]
then
    echo "The service was Stoped!!"

else
    echo "################################################"
    echo "#             Push Server Stopping             #"
    echo "################################################"
    echo "#              Wait .... ~~~!!!!!!!!!!!!!      #"
    echo "################################################"
    kill -9 $SERVICE_PID
fi
}
check_redis(){
    REDIS_PID=$(ps axu|grep "redis-server"|grep -v "grep"|awk '{print $2}')
    if [ ! $REDIS_PID ];then
        echo "Redis is not running！"
        exit 3
    fi
}
case $1 in
    start)
    check_redis
    server_start
    ;;
    stop)
    server_stop
    ;;
    restart)
    server_stop
    check_redis
    server_start
    ;;
    *)
    echo "Use start|stop|restart"
    ;;
esac
