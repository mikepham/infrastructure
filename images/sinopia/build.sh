#!/bin/bash

if [ -d "/tmp/test-services" ]; then
  rm -rf /tmp/test-services;
fi

mkdir /tmp/test-services -p;
chown daemon:root /tmp/test-services -R;

echo "Building container..."
docker build -t test/sinopia:latest .;

echo "Running container..."
docker run --name test-sinopia \
    --environment SINOPIA_PREFIX="https://www.test.com"
    --volume /tmp/test-services/conf:/data/conf;
    --volume /tmp/test-services/packages;/data/packages;
    --rm test/sinopia:latest;

docker rm test-sinopia;
