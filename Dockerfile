FROM dockerfile/ubuntu
MAINTAINER James Badger <james@jamesbadger.ca>

# Install Redis.
RUN \
  cd /tmp && \
  wget http://download.redis.io/redis-stable.tar.gz && \
  tar xvzf redis-stable.tar.gz && \
  cd redis-stable && \
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable*

# Install supplementary packages.
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen

# Add scripts.
ADD run.sh /run.sh
ADD set_redis_password.sh /set_redis_password.sh
ADD set_redis_mode.sh /set_redis_mode.sh
ADD set_redis_workdir.sh /set_redis_workdir.sh
RUN chmod 755 /*.sh

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

EXPOSE 6379
CMD ["/run.sh"]
