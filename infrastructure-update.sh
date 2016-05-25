#!/bin/bash

BASE=/etc/infrastructure
IPADDRESS=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`

echo "Checking for dependencies...";
which realpath > /dev/null;
if [ $? -gt 0 ]; then
  apt-get update > /dev/null;
  apt-get install -y realpath;
fi

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

echo "Checking if machine has sync folder";
dropbox list sync | grep $IPADDRESS > /dev/null;
if [ $? -gt 0 ]; then
  echo "Initializing sync folder for $IPADDRESS...";
  dropbox mkdir sync/$IPADDRESS;
  $SCRIPTPATH/infrastructure-update.sh download;
  if [ $? -gt 0 ]; then
    exit 1;
  fi
fi

case "$1" in
  "download")
    echo "Downloading files for $IPADDRESS...";
    if [ ! -d "$BASE" ]; then
      mkdir -p $BASE;
    fi
    dropbox download sync/$IPADDRESS/ $BASE/;
    exit $?;
  ;;

  "upload")
    echo "Uploading files...";
    dropbox upload $BASE/*.composer sync/$IPADDRESS/;
    dropbox upload $BASE/certs sync/$IPADDRESS/;
    exit $?;
  ;;
esac
