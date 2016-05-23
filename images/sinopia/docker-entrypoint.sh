#!/bin/bash

cd /data/sinopia;
alias ls='ls -lah --color=auto';

ls /data;
ls /data/conf;
ls /data/default;
ls /data/packages;

if [ ! -f "/data/conf/config.yaml" ]; then
  cat /data/default/config.yaml;
  cat /data/default/config.yaml >> /data/conf/config.yaml;
  cat /data/conf/config.yaml;
fi

if [ ! -f "/data/packages/.sinopia-db.json" ]; then
  cat /data/default/.sinopia-db.json;
  cat /data/default/.sinopia-db.json >> /data/packages/.sinopia-db.json;
  cat /data/packages/.sinopia-db.json;
fi
