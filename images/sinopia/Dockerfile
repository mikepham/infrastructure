# Pull base image.
FROM node:argon

RUN mkdir /opt/sinopia/storage/cache -p
RUN echo {"list":[],"secret":"c649864c562c335aa53ce9cd8f64681d05a2f25bbab4c7399bd0c5a9858d0d40"} > /opt/sinopia/storage/cache/.sinopia-db.json
RUN chmod 777 /opt/sinopia/storage/cache/.sinopia-db.json

ADD node_modules/sinopia /opt/sinopia
ADD config.yaml /opt/sinopia/config.yaml

WORKDIR /opt
VOLUME /opt/sinopia/storage

RUN chown daemon:daemon -R /opt/sinopia

USER daemon
EXPOSE 4873

CMD ["/opt/sinopia/bin/sinopia"]
