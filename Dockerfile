FROM php:8.3-fpm

# Instala dependências
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    postgresql-client

# Extensões PHP necessárias
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copia o código do Laravel
COPY . .

# Instala dependências do Laravel
RUN composer install --no-dev --optimize-autoloader

# Permissões
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Copia o entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000

# Usa o entrypoint com retry + migrate + start
CMD ["/entrypoint.sh"]
