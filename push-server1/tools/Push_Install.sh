#!/bin/env bash
#
##############################################################
# Author sam <changwei.wen@redcore.cn>                       #
# Push_Install - Push Server Install     script              #
#                                                            #
# Date: 2018/8/6                                             #
#                                                            #
# System: CentOS 7                                           #
#                                                            #
##############################################################
# Development environment CentOS 7                           #
##############################################################
#
#
echo "################################################"
echo "#             Push Server Installing           #"
echo "################################################"
echo "#              Thank You ~~~!!!!!!!!!!!!!      #"
echo "################################################"
#
# Push Server Home
#
PUSH_HOME=/project/push-server
#
#
#

log_info (){
#
# Failed identifier
#
FAILURE=false
#
case $1 in
success)
    echo
    echo -e " # # # # # # # # # # # # # #\033[32m $LINE1 success    \033[0m# # # # # # # # # # # # # #"
    echo
;;
failure)
    echo
    echo -e " # # # # # # # # # # # # # #\033[31m $LINE1 failure    \033[0m# # # # # # # # # # # # # #"
    echo
    FAILURE=ture
;;
esac
echo
if [ -n "$LINE2" ]
then
    echo -e $LINE2" \c"
fi
#
# End the program if it fails
#
if [ $FAILURE == "ture" ];then
    exit 5
fi
#
# Do a little variable clean-up
#
unset LINE1
unset LINE2
#
}       #End of log_info function
system_release (){
if uname -r |grep "x86_64" &>/dev/null
then
    FLAG_AR_64=ture                     #Tpye x86_64
    if cat /etc/redhat-release|grep "release 7.*" &>null;
    then
        FLAG_OS_7=ture                  #Type CentOS 7
    else
        FLAG_OS_7=false
    fi
else
    LINE1="System_release"
    LINE2="Script runnig conditions are insufficient."
    log_info failure
fi
}       #End of system_release function
#
system_release
#
# Get user input
#
get_answer (){
unset ANSWER
echo
echo $LINE_TXT1
echo
if [ -n "$LINE_TXT2" ];then
    echo -e "$LINE_TXT2 '\c'"
fi
read ANSWER
unset LINE_TXT1
unset LINE_TXT2
}               #End of get_answer function
#
# Process_answer
#
process_answer (){
case $ANSWER in
y|Y|YES|yes|Yes|yEs|yeS|YEs|yES)
    FLAG=yes
;;
*)
    FLAG=no
;;
esac


}           #End of process_answer function
#
# Configuring firewalls
#
rdc_fire (){
if [ $FLAG_OS_7 == "ture" ]
then
    if systemctl status firewalld &>/dev/null
    then
        COMMAND1="firewall-cmd --list-ports"
        COMMAND2="firewall-cmd --permanent --add-port=8080/tcp --zone=public "
        COMMAND3="firewall-cmd --reload "
        $COMMAND1 |grep -w "8080" &>/dev/null || $COMMAND2 &>/dev/null && $COMMAND3 &>/dev/null
        COMMAND4="firewall-cmd --list-ports|grep -w '6379' "
        COMMAND5="firewall-cmd --permanent --add-port=6379/tcp --zone=public "
        COMMAND6="firewall-cmd --reload "
        $COMMAND4 &>/dev/null || $COMMAND5 &>/dev/null && $COMMAND6 &>/dev/null
        LINE1="rdc_fire"
        log_info success
    fi
else
    if service iptables status &>/dev/null
    then
        COMMAND1="iptables -nL"
        COMMAND2="iptables -I INPUT -p tcp --dport 8080 -j ACCEPT"
        $COMMAND1 |grep -w "8080" &>/dev/null || $COMMAND2
        COMMAND3="iptables -nL"
        COMMAND4="iptables -I INPUT -p tcp --dport 6379 -j ACCEPT"
        $COMMAND3 |grep -w "6379" &>/dev/null || $COMMAND4
        LINE1="rdc_fire"
        log_info success
    fi
fi
}       #End of rdc_fire function
#
# Set JDK
#
rdc_java(){
    if [ ! -e /usr/jdk ];then
        ln -s $PUSH_HOME/jdk1.8.0_131  /usr/jdk
    fi
    if [ ! -e /etc/profile.d/push_env.sh ];then
        ln -s $PUSH_HOME/tools/push_env.sh /etc/profile.d/push_env.sh
    fi
}

rdc_redis_start(){
    nohup $PUSH_HOME/redis/bin/redis-server $PUSH_HOME/redis/bin/redis.conf &>/dev/null &
}
rdc_push(){
#
# 获取rdc-manager地址
#
FLAG=no
    until [ $FLAG = "yes" ];do
        LINE_TXT1="Please enter the IP address of rdc-manager"
        LINE_TXT2="Format xxx.xxx.xxx.xxx :"
        get_answer
        RDC_MANAGER=$ANSWER
        LINE_TXT1="The IP address of rdc-manager is '$RDC_MANAGER' "
        LINE_TXT2="Do you confirm that this address is used as the IP address of rdc-manager?[yes|no]"
        get_answer
        process_answer
    done                # End of rdc-manager IP
#
# 获取本机地址作为push-server的IP地址
#
    PUSH_HOST=`ip add|grep -w "inet" |grep -v "127.0.0.1"|awk '{print $2}'|sed '1s@/.*@@'`   # 获取本机IP地址
    sed -i "s/192.168.1.152/$PUSH_HOST/g" $PUSH_HOME/server/application.properties
    sed -i "s/pertest.redcore.cn/$RDC_MANAGER/g" $PUSH_HOME/server/application.properties
}       # End of rdc_push function
#
# Available memory
#
rdc_available_memory(){
    if [ $FLAG_OS_7 = "ture" ];then
        RDC_MEMORY_FREE=$(free -m|sed -n '2p'|awk '{print $NF}')
        PUSH_RUN_MEMORY=$(expr $(expr $RDC_MEMORY_FREE / 3) \* 2)
    else
        RDC_MEMORY_FREE=$(free -m|sed -n '3p'|awk '{print $NF}')
        PUSH_RUN_MEMORY=$(expr $(expr $RDC_MEMORY_FREE / 3) \* 2)
    fi
}

rdc_set_push_tools(){
    sed -i "s/2048m/${PUSH_RUN_MEMORY}m/g" $PUSH_HOME/tools/Push_Tools.sh
}
################    Main Script ##############################
if [ -e $PUSH_HOME ]
#
# If folder $PUSH_HOME exists, it is assumed that rdc_push has been installed
#
then
    LINE1="rdc_push_install"
    LINE2="The Push Server installed"
    log_info failure
else
#
# Whether the parent directory A exists,if no creation exists
#
    if [ ! -e /project ];then
        mkdir -pv /project
    fi
#
# Move the script to the parent directory
#
mv ../../push-server /project
rdc_java
rdc_push
rdc_redis_start
rdc_available_memory
rdc_set_push_tools
rdc_fire
sleep 1
cd $PUSH_HOME/tools
source ./push_env.sh
./Push_Tools.sh start
fi






























