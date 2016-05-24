FROM ubuntu:latest

ENV DROPBOX_API bruk5c0exos52ub
ENV DROPBOX_SECRET bca6gju442yhhe8
ENV TERM dumb

# Install basic dev dependencies.
RUN apt-get update \
;apt-get -y install \
bash-completion \
build-essential \
curl \
dnsutils \
expect \
expect-dev \
git \
iputils-ping \
nodejs \
npm \
python-gpgme \
wget \
; apt-get dist-upgrade -y \
; apt-get upgrade -y \
; apt-get autoremove \
; apt-get autoclean
RUN ln -s /usr/local/bin/nodejs /usr/local/bin/node

# Install node dependencies.
RUN npm install --global grunt-cli gulp-cli ; npm cache clean

# Install dropbox daemon.
RUN wget -O /usr/local/bin/dropbox_uploader.sh \
"https://raw.github.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" \
; chmod +x /usr/local/bin/dropbox_uploader.sh
RUN ln -s /usr/local/bin/dropbox_uploader.sh /usr/local/bin/dropbox

# Start process.
ADD docker-entrypoint.sh /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
