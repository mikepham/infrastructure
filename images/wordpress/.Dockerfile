FROM php:5.6-apache

##
# Set environment variables.
#
ENV WORDPRESS_SHA1 bab94003a5d2285f6ae76407e7b1bbb75382c36e
ENV WORDPRESS_VERSION 4.5.2

##
# Installe dependencies and wordpress.
#
RUN set -x \
  && a2enmod rewrite expires \
  # Install the PHP extensions we need.
  && apt-get update \
  && apt-get install -y \
        libjpeg-dev \
        libpng12-dev \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
  && docker-php-ext-install \
        gd \
        mysqli \
        opcache \
        zip \
  # Set recommended PHP.ini settings.
  # See: https://secure.php.net/manual/en/opcache.installation.php
  && { \
    echo 'opcache.enable_cli=1'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.revalidate_freq=60'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini \
  # Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress.
  && curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
  && echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
  && tar -xzf wordpress.tar.gz -C /usr/src/ \
  && rm wordpress.tar.gz \
  && chown -R www-data:www-data /usr/src/wordpress \
  && apt-get autoclean \
  && apt-get autoremove \
;

##
# Add files from context.
#
ADD docker-entrypoint.sh /entrypoint.sh
RUN set -x \
  && chown www-data:www-data /entrypoint.sh \
  && chmod +x /entrypoint.sh \
;

##
# Define volumes, ports, and entry point.
#
VOLUME /var/www/html
VOLUME /usr/local/etc/php/conf.d

ENTRYPOINT /entrypoint.sh
CMD ["apache2-foreground"]
