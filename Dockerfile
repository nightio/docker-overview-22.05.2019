FROM php:7.3.5-apache

RUN apt-get update; \
    apt-get install -y libzip-dev acl; \
    docker-php-ext-configure zip --with-libzip; \
    docker-php-ext-install -j$(nproc) zip; \
    docker-php-ext-enable opcache; \
    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY docker/php/symfony.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

COPY docker/php/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

WORKDIR /srv/symfony

EXPOSE 80
CMD ["apache2-foreground"]