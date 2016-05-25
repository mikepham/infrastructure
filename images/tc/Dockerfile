# Based on https://github.com/sjoerdmulder/teamcity-agent-docker.git
FROM ubuntu:wily
MAINTAINER support@nativecode.com

##
# Setup some environment variables we'll need later.
#   TEAMCITY_AGENT_PATH     root of the agent files.
#   TEAMCITY_SERVER_URL     URL where the agent can contact TeamCity.
##
ENV TEAMCITY_SERVER_PATH    http://localhost
WORKDIR /data

##
# We have to update the current list of packages to make
# sure the list is indexed and primed.
##
RUN apt-get update \
  && apt-get -y install \
      apparmor \
      apt-utils \
      apt-transport-https \
      aufs-tools \
      ca-certificates \
      cgroup-lite \
      cgroupfs-mount \
      curl \
      dnsutils \
      git-core \
      iputils-ping \
      libltdl7 \
      python-software-properties \
      software-properties-common \
      sudo \
      wget \
  # We need a new context for the following commands, so we use a
  # semi-colon before continuing.
  # Add key and repository for the official docker packages.
  ; apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
      --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
  && echo "deb https://apt.dockerproject.org/repo ubuntu-wily main" \
      >> /etc/apt/sources.list.d/docker.list \
  # Make sure we have the repositories indexed.
  && apt-get update \
  
;

##
# Install depedencies from universe.
##
RUN apt-get -y install \
      build-essential \
      default-jdk \
      default-jre \
      docker-engine \
      mono-complete \
      nodejs \
      npm \
      perl \
      python \
      python-pip \
  # Create a node symlink because the package had a collision in ubuntu.
  && ln -s /usr/bin/nodejs /usr/local/bin/node \
  # Install nodejs global dependencies.
  && npm install --global --production --silent grunt-cli gulp-cli \
  # Add a teamcity user and add to the sudo and docker groups.
  && adduser --disabled-password --gecos "" teamcity \
  && sed -i -e "s/%sudo.*$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/" /etc/sudoers \
  && usermod -a -G docker,sudo teamcity \
  # Generate a list of installed packages for this image version.
  && dpkg --get-selections | grep -v deinstall >> /data/packages.list \
  # Set docker to start when the system starts.
  && systemctl enable docker \
;

# Add files to image and set the entry point, volumes, and posts.
ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD wrapdocker /usr/local/bin/wrapdocker
ENTRYPOINT /docker-entrypoint.sh
VOLUME /var/lib/docker
VOLUME /data
EXPOSE 9090
