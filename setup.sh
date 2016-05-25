#!/bin/bash

echo "";
echo "    Checking for dependencies. This might take a bit.";

##
# Check for the realpath package, which we need below.
which realpath > /dev/null;
if [ $? -gt 0 ]; then
  apt-get update > /dev/null;
  apt-get install -y realpath;
  if [ $? -gt 0 ]; then
    echo "";
    echo "Something went horribly wrong!";
    exit $?;
  fi
fi

##
# Declare variables now that we have realpath.
BASEPATH=/opt/infrastructure
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
    echo "";
    echo "Something went horribly wrong!";
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
      echo "";
      echo "Something went horribly wrong!";
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
    echo "";
    echo "Something went horribly wrong!";
    exit $?;
  fi
  chmod +x /usr/local/bin/dropbox;
fi

##
# Install the dependencies listed in the package.json file,
# which we need to run the JS files.
if [ -d "node_modules" ]; then
  npm update --production --silent > /dev/null;
else
  npm install --production --silent > /dev/null;
fi

if [ $? -gt 0 ]; then
  echo "";
  echo "Something went horribly wrong!";
  exit $?;
fi

##
# Create symlink.
LINK_PATH=/usr/local/bin/infrastructure
if [ ! -L $LINK_PATH ]; then
  echo -n "    Creating symlink...";
  ln -s /opt/infrastructure/infrastructure.sh $LINK_PATH;
  echo "done.";
fi

echo "                                                                             ";
echo "*****************************************************************************";
echo "                                                                             ";
echo "  My part is done. I'm getting off this hamster wheel while you do the rest. ";
echo "                                                                             ";
echo "*****************************************************************************";
echo "                                                                             ";
echo "  Almost there! We need a place to store our super secret sauce recipes and  ";
echo "  we will use Dropbox for that. Because we're opinionated that way.          ";
echo "                                                                             ";
echo "  Please see the github wiki for documentation on how syncing works. In the  ";
echo "  meantime, we recommmend you read this article for how to set up dropbox.   ";
echo "                                                                             ";
echo "    http://xmodulo.com/access-dropbox-command-line-linux.html                ";
echo "                                                                             ";
echo "*****************************************************************************";
echo "                                                                             ";
echo "  REQUIRED: Configure dropbox.                                               ";
echo "                                                                             ";
echo "  OPTIONAL: Run the sample composer file.                                    ";
echo "                                                               . _           ";
echo "       > cd /etc/infrastrcture                              .--H\LC__        ";
echo "       > infrastructure generate                       -_--\\ 'H\_/__L       ";
echo "       > cd demo                                   - --_ _-] :)=(_L__        ";
echo "       > docker-composer build                       - ----// .H/\\__T       ";
echo "       > docker-composer up                                 '--H-^~          ";
echo "                                                                '            ";
echo "*****************************************************************************";
