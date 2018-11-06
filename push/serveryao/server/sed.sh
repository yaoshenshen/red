#!/bin/bash
set -e
[[ "${DEBUG}"  == "true" ]] && set -x

: ${Redconf:= /project/server/application.properties}
: ${PUSH_HOME:=/project}
#set ip
[ -z "$Pushaddr" ] && export Pushaddr=$(ifconfig|grep -w "inet" |grep -v "127.0.0.1"|awk '{print $2}'|sed '1s@/.*@@')
sed -i "s/192.168.1.152/$Pushaddr/g" $PUSH_HOME/server/application.properties  
exec "$@"
