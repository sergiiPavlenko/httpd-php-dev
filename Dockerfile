FROM fpfis/httpd-php:7.2

ENV COMPOSER_VERSION 1.6.5
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH ${PATH}:/root/.composer/vendor/bin

RUN curl -L https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar > /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer

RUN apk add git mysql-client sqlite --no-cache
RUN apk add autoconf make g++ gcc -t build-stack --no-cache && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug && \
    apk del build-stack --purge

### Disable prod settings :
RUN rm /usr/local/etc/php/conf.d/95-prod.ini &&\
    rm /etc/apache2/conf.d/prod.conf
