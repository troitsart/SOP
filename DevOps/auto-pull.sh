#!/bin/bash

cd /opt/repos

while true;
do
	git fetchß
	if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
		git pull
	fi
	sleep 5
done