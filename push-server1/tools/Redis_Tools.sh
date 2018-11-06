#!/bin/env bash
#
##############################################################
# Author sam <changwei.wen@redcore.cn>                       #
# Push_Tools - Redis manager script                          #
#                                                            #
# Date: 2018/8/7                                             #
#                                                            #
# System: CentOS 7                                           #
#                                                            #
##############################################################
# Development environment CentOS 7                           #
##############################################################
#
#
SERVICE="redis-server"                   # Manager service
#
# Service home_dir
#
SERVICE_HOME=/project/push-server/redis
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
    echo "#             Redis Server Starting            #"
    echo "################################################"
    echo "#              Wait .... ~~~!!!!!!!!!!!!!      #"
    echo "################################################"
    nohup ./bin/redis-server ./bin/redis.conf &>/dev/null &
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
    echo "#             Redis Server Stopping            #"
    echo "################################################"
    echo "#              Wait .... ~~~!!!!!!!!!!!!!      #"
    echo "################################################"
    kill -9 $SERVICE_PID
fi
}
case $1 in
    start)
    server_start
    ;;
    stop)
    server_stop
    ;;
    restart)
    server_stop
    server_start
    ;;
    *)
    echo "Use start|stop|restart"
    ;;
esac
