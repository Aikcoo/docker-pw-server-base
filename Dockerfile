FROM php:7.1-apache

RUN pecl install -o -f redis-4.3.0 \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis \
    && a2enmod rewrite

RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libjpeg62-turbo-dev \
        libpng-dev libxpm-dev \
        libfreetype6-dev \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure gd \
    --with-gd \
    --with-webp-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-xpm-dir \
    --with-freetype-dir \
    --with-freetype

RUN docker-php-ext-install gd pdo pdo_mysql

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --1 \
    && rm -rf composer-setup.php \
    && mv composer.phar /usr/local/bin/composer
