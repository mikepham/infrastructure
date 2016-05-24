FROM ubuntu:latest

RUN apt-get -y install \
  git
  wget \
  ; apt-get autoremove
  ; apt-get autoclean

ADD docker-entrypoint.sh /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
