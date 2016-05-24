#!/bin/bash

CALLER_PATH=$PWD

##
# Setup an install dropbox so we can store our sensitive data
# like passwords and certs.
if [ ! -f "/usr/local/bin/dropbox" ]; then
  wget -O /usr/local/bin/dropbox \
    "https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh";
  chmod +x /usr/local/bin/dropbox;
fi

##
# Get the infrastructure project along with submodules.
if [ ! -d "/opt/infrastructure" ]; then
  git clone --recursive https://github.com/mikepham/infrastructure.git /opt/infrastructure;
fi

cd /opt/infrastructure;

##
# Make sure we have the node dependencies we need.
if [ -d "node_modules" ]; then
  npm update --production --silent;
else
  npm install --production --silent;
fi

##
# Download and make the update script executable.
if [ ! -f "/usr/local/bin/infrastructure-update.sh" ]; then
  wget -O /usr/local/bin/infrastructure-update.sh \
    https://www.dropbox.com/s/kxx3h578i6bqzkl/infrastructure-update.sh?dl=0;
  chmod +x /usr/local/bin/infrastructure-update.sh;
fi

##
# Run our generator that takes .composer JSON files and
# turns them into docker-compose.yml files and ensure
# that they live in predictable locations.
node ./index.js

cd $CALLER_PATH
