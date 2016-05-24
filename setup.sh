#!/bin/bash

CALLER_PATH=$PWD

if [ ! -d "/opt/infrastructure" ]; then
  git clone --recursive https://github.com/mikepham/infrastructure.git /opt/infrastructure;
fi

cd /opt/infrastructure;

if [ -d "node_modules" ]; then
  npm update --prefix /opt/infrastructure --production --silent;
else
  npm install --prefix /opt/infrastructure --production --silent;
fi

if [ ! -f "/usr/local/bin/infrastructure-update.sh" ]; then
  wget -O /usr/local/bin/infrastructure-update.sh \
    https://www.dropbox.com/s/kxx3h578i6bqzkl/infrastructure-update.sh?dl=0;
  chmod +x /usr/local/bin/infrastructure-update.sh;
fi

node /opt/infrastructure/index.js

cd $PWD
