#!/bin/bash

cd /opt/repos

while true;
do
	git fetch
	if [ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]; then
		git pull
		service apache2 reload
	fi
	sleep 5
done
