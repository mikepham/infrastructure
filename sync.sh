#!/bin/bash

BASEPATH=/opt/infrastructure
SYNCPATH=/etc/infrastructure
IPADDRESS=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`

echo "Checking if machine has sync folder";
dropbox list sync | grep $IPADDRESS > /dev/null;
if [ $? -gt 0 ]; then
  echo "Initializing sync folder for $IPADDRESS...";
  dropbox mkdir sync/$IPADDRESS;
  $BASEPATH/sync.sh download;
  if [ $? -gt 0 ]; then
    exit 1;
  fi
fi

case "$1" in
  "download")
    echo "Downloading files for $IPADDRESS...";
    if [ ! -d "$SYNCPATH" ]; then
      mkdir -p $SYNCPATH;
    fi
    dropbox download sync/$IPADDRESS/ $SYNCPATH/;
    exit $?;
  ;;

  "upload")
    echo "Uploading files...";
    dropbox upload $SYNCPATH/*.composer sync/$IPADDRESS/;
    if [ -d "$SYNCPATH/certs" ]; then
      dropbox upload $SYNCPATH/certs sync/$IPADDRESS/;
    fi
    exit $?;
  ;;
esac
