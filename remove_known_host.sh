#!/bin/bash


LOCATION=~/.ssh/known_hosts
LOCATION=$(readlink -f $LOCATION)
TMPFILE=~/.tmp_known_hosts.txt

while true; do
    [ -z $1 ] && echo "Specify host to remove from $LOCATION."
    [ -z $1 ] && read HOST
    [ -z $1 ] || HOST=$1; shift
    if
	grep -q "$HOST" $LOCATION
    then
	grep -v $HOST $LOCATION > $TMPFILE
        sudo mv $TMPFILE $LOCATION
        break
    else
	echo "Cannot locate specified hosts..."
        break
    fi
done

