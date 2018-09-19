FROM fpfis/httpd-php:7.1

RUN apt-get update && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

ENV COMPOSER_VERSION 1.6.5
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH ${PATH}:/root/.composer/vendor/bin

RUN curl -L https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar > /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer

RUN apk add git patch mysql-client sqlite --no-cache
RUN apk add autoconf make g++ gcc -t build-stack --no-cache && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    apk del build-stack --purge

### Disable prod settings :
RUN rm /usr/local/etc/php/conf.d/95-prod.ini &&\
    rm /etc/apache2/conf.d/prod.conf

### Add dev settings :
ADD dev.ini /usr/local/etc/php/conf.d/95-dev.ini

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
