#!/bin/bash

if [ -f /.redis_workdir_set ]; then
	echo "Redis workdir already set!"
	exit 0
fi

touch /etc/redis/redis_default.conf
echo "dir ./" >> /etc/redis/redis_default.conf

touch /.redis_workdir_set
