FROM php:7.4-fpm as geekshubs-php-fpm74
ARG TIMEZONE

MAINTAINER Geekshubs

RUN apt-get update && apt-get install -y \
    git \
    openssl \
    unzip \
    wget \
    supervisor

RUN apt-get install -y zlib1g-dev
RUN apt-get install -y libpq-dev
RUN apt-get install -y libc-client-dev libkrb5-dev

RUN wget -O phpunit.phar https://phar.phpunit.de/phpunit-7.4.0.phar && \
chmod +x phpunit.phar &&  cp phpunit.phar /usr/local/lib/php
#Instalación Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version


#Modificar php-fpm 
ADD ./www.conf   /usr/local/etc/php-fpm.d/www.conf

#Setear TimeZone.
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo "UTC" > /etc/timezone
RUN echo '[PHP]\ndate.timezone ="UTC"' > /usr/local/etc/php/php.ini

# Install Postgre PDO
RUN apt-get install -y libxml2-dev
RUN apt-get install -y libmcrypt-dev
RUN apt-get install -y libcurl4-openssl-dev
RUN apt-get update -y && \
    apt-get install -y libmcrypt-dev
RUN docker-php-ext-install bcmath
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install sockets
RUN docker-php-ext-install dom
RUN docker-php-ext-install session
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pgsql
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-install curl
RUN docker-php-ext-install xmlrpc
RUN docker-php-ext-install xmlwriter
RUN docker-php-ext-install xml
RUN docker-php-ext-install curl

#install Imagemagick & PHP Imagick ext
RUN apt-get update && apt-get install -y \
        libmagickwand-dev --no-install-recommends

RUN pecl install imagick && docker-php-ext-enable imagick

#Configuración XDEBug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug
RUN echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.remote_connect_back=1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.idekey = PHPSTORM' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.remote_autostart=1' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.max_nesting_level=4096' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
