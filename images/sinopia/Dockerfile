FROM node:0.10.45
MAINTAINER "Mike Pham (support@nativecode.com)"

ENV SINOPIA_PREFIX="https://localhost"

RUN mkdir -p /data/conf;
RUN mkdir -p /data/default;
RUN mkdir -p /data/packages;

RUN npm install --global --prefix /data/sinopia --production --silent \
  sinopia > /dev/null;

RUN chown daemon:root /data -R;

USER daemon
ADD docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
