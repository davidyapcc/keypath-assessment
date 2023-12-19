# Use the official PHP image as the base
FROM php:8.1-fpm

# Install required PHP extensions
RUN apt-get update && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install pdo_mysql

# Enable OPcache extension
RUN docker-php-ext-enable opcache

# Set OPcache settings (optional - adjust as needed)
RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
RUN echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Install necessary packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       git \
       unzip \
&& rm -rf /var/lib/apt/lists/*

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy Drupal project into the container
COPY . /var/www/html/

# Install project dependencies using Composer
RUN composer install

# Expose port 9000 for PHP-FPM
EXPOSE 9000
