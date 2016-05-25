#!/bin/bash

echo "Checking for dependencies...";

##
# Check for the realpath package, which we need below.
which realpath > /dev/null;
if [ $? -gt 0 ]; then
  apt-get update > /dev/null;
  apt-get install -y realpath;
  if [ $? -gt 0 ]; then
    echo "Something went horribly wrong!";
    cd $CALLER;
    exit $?;
  fi
fi

##
# Declare variables now that we have realpath.
BASEPATH=/opt/infrastructure
CALLER=$PWD
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
IPADDRESS=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`

##
# If we don't have a copy of the git repository, pull
# it down from github. We'll have it recurse as well
# so we can get the required submodules.
if [ ! -d $BASEPATH ]; then
  git clone --recursive https://github.com/mikepham/infrastructure.git $BASEPATH;
  if [ $? -gt 0 ]; then
    echo "Something went horribly wrong!";
    cd $CALLER;
    exit $?;
  fi
  chmod +x $BASEPATH/infrastructure.sh;
  ln -s $BASEPATH/infrastructure.sh /usr/local/bin/infrastructure;
fi

cd $BASEPATH;

##
# Check if node.js is installed. Ubuntu had to rename
# their file to nodejs, so we'll create a symlink if
# it doesn't already exist.
NODE_NORMAL=`which node`;
NODE_UBUNTU=`which nodejs`;
if [ ! NODE_NORMAL ]; then
  if [ ! NODE_UBUNTU ]; then
    apt-get update > /dev/null;
    apt-get install -y nodejs npm;
    if [ $? -gt 0 ]; then
      echo "Something went horribly wrong!";
      cd $CALLER;
      exit $?;
    fi
  fi
  ln -s `which nodejs` /usr/local/bin/node;
fi

##
# Install dropbox so we can store our sensitive data like
#  passwords and certs.
if [ ! -f "/usr/local/bin/dropbox" ]; then
  wget -O /usr/local/bin/dropbox \
    "https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh";
  if [ $? -gt 0 ]; then
    echo "Something went horribly wrong!";
    cd $CALLER;
    exit $?;
  fi
  chmod +x /usr/local/bin/dropbox;
  echo "Plesure configure dropbox before continuing.";
  exit 1;
fi

##
# Install the dependencies listed in the package.json file,
# which we need to run the JS files.
if [ -d "node_modules" ]; then
  npm update --production --silent;
else
  npm install --production --silent;
fi

if [ $? -gt 0 ]; then
  echo "Something went horribly wrong!";
  cd $CALLER;
  exit $?;
fi

##
# Create symlink.
LINK_PATH=/usr/local/bin/infrastructure
if [ ! -L $LINK_PATH ]; then
  echo "Creating symlink...";
  ln -s /opt/infrastructure/infrastructure.sh $LINK_PATH;
fi

echo "Hey! If we made it this far, everything installed!";
echo "You'll need to setup your dropbox. We recommend creating an app folder.";
echo "Just type 'dropbox' and follow the instructions.";

cd $CALLER;
