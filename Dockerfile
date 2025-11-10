FROM nginx:alpine

# Copy your website files
COPY . /usr/share/nginx/html/

# Copy your nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Install PHP and dependencies
RUN apk add --no-cache php83 php83-fpm

# Create PHP-FPM config (correct path for PHP 8.3)
RUN echo 'listen = 9000' >> /etc/php83/php-fpm.d/www.conf

# Start both services
CMD php-fpm83 -D && nginx -g 'daemon off;'