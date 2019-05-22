FROM php:7.2-apache

RUN apt-get update
RUN apt-get install -y libzip-dev

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN docker-php-ext-configure zip --with-libzip; \
    	docker-php-ext-install -j$(nproc) zip

COPY docker/php/symfony.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

RUN docker-php-ext-enable opcache

WORKDIR /srv/symfony