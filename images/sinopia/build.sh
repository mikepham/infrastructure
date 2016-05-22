#!/bin/bash

echo "Building container..."
docker build -t test/sinopia:latest .;

echo "Running container..."
docker run --name test-sinopia --rm test/sinopia:latest;

read -p "Press [any] key to clean up."

docker stop test-sinopia;
docker rm test-sinopia;
docker rmi test-sinopia
