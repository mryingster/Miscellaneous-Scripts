#!/bin/bash

case $(cat /etc/issue | sed -e 's/Kernel.*$//') in
    *RHEL* | *Red* ) SYSTEM="Red Hat Enterprise Linux" ;;
    *Cent*) SYSTEM="Community Enterprise OS" ;;
    *SUSE* | *SLES* ) SYSTEM="SUSE Linux Enterprise Server" ;;
    *Debian*) SYSTEM="Debian" ;;
    *Ubuntu*) SYSTEM="Ubuntu" ;;
    *) SYSTEM="Unrecognized operating system" ;;
esac

VERSION=$(cat /etc/issue | tr -d '\r\n' | sed -e 's/.*\(\s[0-9].*[0-9]\s\).*/\1/' | sed -e 's/^\s//;s/\s$//' )

if
    [ -e /etc/redhat-release ]
then
    SYSTEM="Red Hat Enterprise Linux"
    VERSION=$(cat /etc/redhat-release | tr -d '\r\n' | sed -e 's/.*\(\s[0-9].*[0-9]\s\).*/\1/' | sed -e 's/^\s//;s/\s$//' )
fi

ARCHITECTURE=$(uname -i )
KERNEL=$(uname -r )
CPU_Speed=$(cat /proc/cpuinfo | grep MHz | head -1 | awk '{print$4}')
CPU_Count=$(cat /proc/cpuinfo | grep processor | wc | awk '{print$1}')
CPU_Model=$(cat /proc/cpuinfo | grep "model name" | head -1 | sed -e 's/[^:]*: //')
MEM_Total=$(echo "scale=2; $(cat /proc/meminfo | grep MemTotal | awk '{print$2}') / 1024/1024" | bc)
Current_User=$(whoami)
UpTime=$(uptime | sed -e 's/.*\ up\ \([^,]*,[^,]*\).*/\1/')
IntIPAddress=( $(ifconfig | grep "flags" | awk '{print $1}' | sed -e 's/://') )

printf "Operating System : \033[1m%s %s\033[0m\n" "$SYSTEM" "$VERSION"
printf "Kernel           : \033[1m%s\033[0m\n" "$KERNEL"
printf "Architecture     : \033[1m%s\033[0m\n" "$ARCHITECTURE"
printf "\n"
printf "CPU Clock Speed  : \033[1m%s\033[0m\n" "$CPU_Speed"
printf "CPU Cores        : \033[1m%s\033[0m\n" "$CPU_Count"
printf "CPU Model        : \033[1m%s\033[0m\n" "$CPU_Model"
printf "System Memory    : \033[1m%s\033[0m\n" "$MEM_Total GB"
printf "\n"
printf "Logged in as     : \033[1m%s\033[0m\n" "$Current_User"
printf "Up Time          : \033[1m%s\033[0m\n" "$UpTime"
printf "\n"
for i in ${IntIPAddress[@]}; do
    address=$(ifconfig $i | grep "inet " | awk '{print $2}' | sed -e 's/addr://')
    printf "Addr %-12s: \033[1m%s\033[0m\n" "$i" "$address"
done
