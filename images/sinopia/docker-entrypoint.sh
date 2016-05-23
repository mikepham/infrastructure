#!/bin/bash

cd /opt/sinopia;

if [ ! -f "/data/sinopia/config.yaml" ]; then
  cat /opt/sinopia/conf.d/config.yaml | sed -e 's@{{PREFIX}}@'"$SINOPIA_PREFIX"'@' >> /data/sinopia/config.yaml;
fi

if [ ! -d "/data/sinopia/cache" ]; then
  mkdir -p /data/sinopia/cache;
  chown daemon:root /data/sinopia/cache;
  cat /opt/sinopia/conf.d/.sinopia-db.json >> /data/sinopia/cache/.sinopia-db.json;
fi

if [ ! -d "/data/sinopia/logs" ]; then
  mkdir -p /data/sinopia/logs;
  chown daemon:root /data/sinopia/logs;
fi

if [ ! -d "/opt/sinopia/htpasswd" ]; then
  echo "admin:`mkpasswd --method=sha-512 admin`" >> /opt/sinopia/htpasswd
  chown daemon:root /opt/sinopia/htpasswd;
  chmod u=rw,g=rw,o=rw /opt/sinopia/htpasswd;
  cat /opt/sinopia/htpasswd;
fi

echo "***********************************************************************************"
echo "***********************************************************************************"
cat /data/sinopia/config.yaml;
echo "***********************************************************************************"
echo "***********************************************************************************"

echo "Starting Sinopia..."
su - daemon -s /bin/bash -c "sinopia -c /data/sinopia/config.yaml";
