#!/bin/bash

set -e

Usage ()
{
    echo ""
    echo "Sniper v0.2"
    echo ""
    echo "Use Sniper to find processes by name and selectively kill them."
    echo ""
    echo "Usage:"
    echo ""
    echo "    sniper [options] <process name>"
    echo ""
    echo "Options:"
    echo ""
    echo "    -f  Find - Displays matching processes"
    echo "    -d  Debug - Displays debugging messages"
    echo "    -v  Verbose - Always asks for confirmation"
    echo "    -a  Killall - Kills all matching processes without confirmation"
    echo "    -h  Help - Show this page"
    echo ""
    exit
}

while true; do
    case $1 in
	-f) findpid=true;;
	-d) debug=true;;
	-v) verbose=true;;
	-a) killall=true;;
	-h | "") Usage;;
	* ) break;;
    esac
    shift
done

#target=$(echo $1 | sed -e 's/\([a-z]\)/\[\1\]/') #Old method, inneffective

UtilityName=$(basename $0)
process=( $(ps aux | grep -v grep | grep -v "$UtilityName" | grep -i $1 | awk '{print $2"_"$1"_"$11":"$12}' | sed -e 's/\[//g;s/\]//g') )

[ "$debug" = true ] && ( echo "Processes Found:"; for i in "${process[@]}"; do echo $i; done; echo "")

if
    [ "$findpid" = true ]
then
    echo "Matching Processes:"; 
    for i in "${process[@]}"; do 
	echo $i; 
    done; 
    exit; 
fi

killfunc ()
{
    pid=$(echo $1 | sed -e 's/_/ /g' | awk '{print $1}' )
    echo "Killing PID: $pid"
    kill "$pid"

    timer=0 #Have timeout for process to quit before forcing
    while ps aux | grep -v grep | grep -v $2 | grep -q $pid; do #kill -0 $pid; do
	[ "$timer" = "0" ] && echo "Waiting for process to terminate..."
	timer=$(($timer+1))
	[ "$debug" = true ] && echo $timer
	if 
	    [ "$timer" = "4" ] 
	then
	    echo "Process $pid failed to terminate. Force quit?"
	    select yn in "Yes" "No"; do
		case $yn in
		    Yes ) kill -9 $pid; break;;
		    No ) break;;
		esac
	    done
	    break;
	fi
	sleep 1
    done
}

if
    [ "${process[0]}" = "" ]
then
    echo "No Matching Process Found"
    exit;
elif 
    [ "${process[1]}" = "" ] && [ "$verbose" != "true" ]
then
    [ "$debug" = true ] && echo "No second string"
    killfunc "${process[0]}" $UtilityName;
elif
    [ "$killall" = "true" ]
then
    for i in "${process[@]}"; do
        killfunc $i $UtilityName;
    done;
else
    echo "Select a process to kill"
    select i in "${process[@]}" "Kill_All" "Cancel"; do
	case $i in
	    Cancel) exit;;
	    Kill_All) for n in "${process[@]}";	do killfunc $n $UtilityName; done; break;;
            $i) killfunc $i $UtilityName; break;;
	    * ) echo "Invalid Option";;
	esac
    done
fi

exit 0;