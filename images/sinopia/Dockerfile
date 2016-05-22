FROM node:4.4.4
MAINTAINER "Mike Pham (support@nativecode.com)"

WORKDIR /opt/sinopia
ADD conf/config.yaml /data/config.yaml
ADD conf/.sinopia-db.json /data/packages/.sinopia-db.json
RUN npm install sinopia --production --silent

USER daemon
EXPOSE 4873

VOLUME /data

ENTRYPOINT ["/opt/sinopia/node_modules/sinopia/bin/sinopia", "-c", "/data/config.yaml"]
