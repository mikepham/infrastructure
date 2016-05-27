#!/bin/bash

export WORDPRESS_DB_CREATOR_PASSWORD=root-password
export WORDPRESS_DB_CREATOR_USER=root
export WORDPRESS_DB_PASSWORD=user-password
export WORDPRESS_DB_USER=user-name
export WORDPRESS_DB_NAME=test
export WORDPRESS_DB_HOST=localhost
export WORDPRESS_TABLE_PREFIX=test_

if [ -e wp-config.php ]; then
  rm wp-config.php
fi

./docker-entrypoint.sh apache2x

if [ -e wp-config.php ]; then
  cat wp-config.php
fi
