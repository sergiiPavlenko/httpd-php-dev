FROM fpfis/httpd-php:7.1

ENV COMPOSER_VERSION 1.6.5
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH ${PATH}:/root/.composer/vendor/bin

RUN curl -L https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar > /usr/local/bin/composer

RUN chmod +x /usr/local/bin/composer
RUN composer global require hirak/prestissimo

RUN apk add git mysql-client sqlite --no-cache
RUN apk add autoconf make g++ gcc -t build-stack --no-cache && \
    pecl install xdebug && \
    echo "zend_extension=xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini && \ 
    apk del build-stack --purge
