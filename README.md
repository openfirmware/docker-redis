# docker-redis

Base docker image to run a Redis server built from Redis stable.

## Building a tagged release from Github

As an alternative to the [Docker Index](https://index.docker.io/), an image can be created from my Github repository:

	# docker build -t openfirmware/redis github.com/openfirmware/docker-redis.git

Once built, the image will be available locally as `openfirmware/redis`. The command can be re-run to update the image with any changes to the Dockerfile.

## Running the Redis server

Redis highly recommends enabling VM memory overcommit. Docker cannot do this on a container-only basis, it must be enabled on your Docker host system. To immediately enable it:

	# sysctl vm.overcommit_memory=1

If the value is not set, or is set to 0, then this container will still run but [background saves by Redis might fail](http://redis.io/topics/faq#background-saving-is-failing-with-a-fork-error-under-linux-even-if-i39ve-a-lot-of-free-ram). If you have already started docker-redis with overcommit disabled, you can stop the container with docker, set the overcommit setting on your docker host, and then start your docker-redis container again.

Run the following command to start Redis:

	# docker run -d -p 6379:6379 openfirmware/redis

The first time that you run your container, a new random password will be set. To get the password, check the logs of the container by running:

	# docker logs <CONTAINER_ID>

You will see an output like the following:

	========================================================================
	You can now connect to this Redis server using:

	    redis-cli -a 5elsT6KtjrqVtOitprnDm7M9Vgz0MGgu -h <host> -p <port>

	Please remember to change the above password as soon as possible!
	========================================================================

In this case, `5elsT6KtjrqVtOitprnDm7M9Vgz0MGgu` is the password set. You can then connect to Redis:

	$ redis-cli -a 5elsT6KtjrqVtOitprnDm7M9Vgz0MGgu

Done!

### Running with a custom password

If you want to use a preset password instead of a random generated one, you can set the environment variable `REDIS_PASS` to your specific password when running the container:

	# docker run -d -p 6379:6379 -e REDIS_PASS="mypass" openfirmware/redis

You can now test your deployment:

	$ redis-cli -a mypass

### Running as an LRU cache

In order to run Redis as a cache that will delete older entries when the memory fills up provide the following additional environment variables:

	# docker run -d -p 6379:6379 -e REDIS_MODE="LRU" -e REDIS_MAXMEMORY="256mb" openfirmware/redis

where `REDIS_MODE` is `LRU` and `REDIS_MAXMEMORY` is the memory limit in which Redis will start deleting the less recently used (LRU) keys. It will use the `allkeys-lru` algorithm.

More info at: http://redis.io/topics/lru-cache

### Running with a persistent data directory (creates `dump.rdb`)

To store the [Redis data directory](http://redis.io/topics/persistence) on the docker host, in the `/data` directory:

	# docker run -d -p 6379:6379 -v <data-dir>:/data openfirmware/redis

## Custom Configuration

This image runs Redis using a custom `.conf` file, which only overrides certain settings; the original [`/etc/redis/redis.conf`](http://download.redis.io/redis-stable/redis.conf) file is ignored.

## Credits

* [dockerfile/redis](https://github.com/dockerfile/redis)
* [Original docker-redis repository](https://github.com/tutumcloud/tutum-docker-redis) created by tutum.co
