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
    dropbox -h -p download sync/$IPADDRESS/certs $SYNCPATH/;
    dropbox -h -p download sync/$IPADDRESS/composers $SYNCPATH/;
    exit $?;
  ;;

  "upload")
    echo "Uploading files...";
    dropbox -h -p -s upload $SYNCPATH/certs sync/$IPADDRESS/;
    dropbox -h -p -s upload $SYNCPATH/composers sync/$IPADDRESS/;
    exit $?;
  ;;
esac
