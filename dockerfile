FROM php:7.4-fpm
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        zip \
        curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php \
    && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer
RUN apt-get install script and pass it to execute: curl -sL https://deb.nodesource.com/setup_4.x | bash
RUN apt-get install -y nodejs npm
RUN npm i -g npm@next

WORKDIR /var/www/html

RUN mkdir vendor
RUN mkdir node_modules

COPY ./app/ .
RUN chmod +x artisan

RUN composer install --optimize-autoloader
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache
RUN npm install
