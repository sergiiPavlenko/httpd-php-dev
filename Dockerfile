FROM fpfis/httpd-php:5.6

ENV COMPOSER_VERSION 1.6.5
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH ${PATH}:/root/.composer/vendor/bin

RUN curl -L https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar > /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer
RUN composer global require hirak/prestissimo

RUN apk add git mysql-client sqlite --no-cache
RUN apk add autoconf make g++ gcc -t build-stack --no-cache && \
    pecl install xdebug-2.5.5 && \
    docker-php-ext-enable xdebug && \
    apk del build-stack --purge
