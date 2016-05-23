FROM node:0.10.45
MAINTAINER "Mike Pham (support@nativecode.com)"

# Environment variables.
ENV SINOPIA_PREFIX https://localhost

# Run package installer first so rebuilding the image is faster.
RUN npm install --global --prefix /opt/sinopia --production --silent sinopia > /dev/null
RUN chown daemon:root -R /opt/sinopia ; chown daemon:root -R /data
RUN ln -s /opt/sinopia/bin/sinopia /usr/local/bin/sinopia

# App contents.
WORKDIR /opt/sinopia/conf.d
ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD templates/config.yaml config.yaml
ADD templates/.sinopia-db.json .sinopia-db.json

# Expose ports and volumes.
EXPOSE 4873
VOLUME ["/data/sinopia"]

# Run process.
ENTRYPOINT ["/docker-entrypoint.sh"]
