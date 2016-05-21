#!/bin/bash

case "$1" in
    -d|--delete)
        docker stop webmin;
        docker rm webmin;
        docker rmi webmin;
        docker rmi nativecode/webmin;
    ;;

    *)
        docker build -t nativecode/webmin:latest . ;
        docker run --name webmin --rm -p 10000:10000 nativecode/webmin:latest;
    ;;
esac

