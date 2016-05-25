#!/bin/bash

CALLER_PATH=$PWD

if [ ! -L "/usr/local/bin/generate-composers" ]; then
  SCRIPT=`realpath $0`
  SCRIPTPATH=`dirname $SCRIPT`

  ln -s $SCRIPTPATH/generate-composers.sh /usr/local/bin/generate-composers;
fi

if [ ! -L "/usr/local/bin/node" ]; then
  apt-get update > /dev/null;
  apt-get install -y nodejs npm;
  ln -s `which nodejs` /usr/local/bin/node;
fi

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
# Symlink the script if it doesn't exist.
if [ ! -L "/usr/local/bin/infrastructure" ]; then
  echo "Creating symlink..."
  ln -s /opt/infrastructure/infrastructure-update.sh /usr/local/bin/infrastructure;
fi

##
# Run our generator that takes .composer JSON files and
# turns them into docker-compose.yml files and ensure
# that they live in predictable locations.
node ./index.js

cd $CALLER_PATH
