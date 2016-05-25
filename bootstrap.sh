#!/bin/bash

BASEPATH=/opt/infrastructure

##
# If the repository hasn't been installed yet, we have
# to download it via git, which we'll check exists and
# install from apt if not.
if [ ! -d "/opt/infrastructure" ]; then
  GIT=`which git`;
  if [ $? -gt 0 ]; then
    apt-get update;
    apt-get install -y git;
  fi
  git clone --recursive https://github.com/nativecode-dev/infrastructure.git $BASEPATH;
  chmod +x $BASEPATH/infrastructure.sh;
  chmod +x $BASEPATH/setup.sh;
  chmod +x $BASEPATH/sync.sh;
fi

$BASEPATH/infrastructure.sh setup;
