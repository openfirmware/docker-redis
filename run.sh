#!/bin/bash

if [ ! -f /.redis_workdir_set ]; then
	/set_redis_workdir.sh
fi
if [ ! -f /.redis_mode_set ]; then
	/set_redis_mode.sh
fi
if [ ! -f /.redis_password_set ]; then
	/set_redis_password.sh
fi

sysctl vm.overcommit_memory=1 > /dev/null
exec /usr/local/bin/redis-server /etc/redis/redis_default.conf
