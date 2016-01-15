#!/bin/sh

strongswan statusall | grep child | awk -F ":" '{ print $1 }' > /etc/strongswan/reconntmp.txt

cat /etc/strongswan/reconntmp.txt | while read line
do
    status=`strongswan status | grep $line`
    if [ x"$status" = x ]; then
        strongswan up $line &
    else
        echo $status
    fi
done
