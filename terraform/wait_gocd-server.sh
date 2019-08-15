#!/bin/bash
#Wait for resource readyness

host_ip="$1"

until $(nc -zv -w 2 $host_ip 22); do 
	sleep 1
done
sleep 5

../ansible/gocd.sh
