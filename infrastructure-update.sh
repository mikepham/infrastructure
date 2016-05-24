#!/bin/bash

BASE=/etc/infrastructure
IPADDRESS=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`

echo "Checking if machine has sync folder";
dropbox list sync | grep $IPADDRESS > /dev/null;
if [ $? -gt 0 ]; then
  echo "Initializing sync folder for $IPADDRESS...";
  dropbox mkdir sync/$IPADDRESS;
  /usr/local/bin/infrastructure-update.sh download;
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
    dropbox download sync/$IPADDRESS/composers $BASE/;
    exit $?;
  ;;

  "upload")
    echo "Uploading files...";
    dropbox upload $BASE/*.composer sync/$IPADDRESS/;
    exit $?;
  ;;

  "x-upload")
    echo "Updating script on server...";
    dropbox upload /usr/local/bin/infrastructure-update.sh infrastructure-update.sh;
    exit $?;
  ;;

  "x-update")
    echo "Updating script...";
    wget -O /usr/local/bin/infrastructure-update.sh \
      https://www.dropbox.com/s/kxx3h578i6bqzkl/infrastructure-update.sh?dl=0;
    exit $?;
  ;;

  *)
    echo "UNKNOWN COMMAND";
    echo "";
    echo "infrastructure.sh [command]";
    echo "download        Download sync folder contents.";
    echo "upload          Upload contents to sync folder.";
    echo "x-upload        Uploads the script to the server.";
    echo "x-update        Update script.";
  ;;
esac
