#!/bin/bash

$SCRIPTDIR=$PWD

cd /var/opt/infrastructure/images/sinopia
clear;

docker build -t test/sinopia:latest .;
docker run --name test-sinopia --rm test/sinopia:latest;

read -p "Press [any] key to clean up."

docker rm test-sinopia;
docker rmi test-sinopia
clear;

cd $PWD
