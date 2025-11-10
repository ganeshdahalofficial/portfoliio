FROM nginx:alpine

# Copy your website files
COPY . /usr/share/nginx/html/

# Copy your nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Install PHP and dependencies
RUN apk add --no-cache php php-fpm

# Create PHP-FPM config
RUN echo 'listen = 9000' >> /etc/php8/php-fpm.d/www.conf

# Start both services
CMD php-fpm8 -D && nginx -g 'daemon off;'