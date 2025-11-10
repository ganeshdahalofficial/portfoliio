FROM nginx:alpine

# Copy your website files
COPY . /usr/share/nginx/html/

# Copy your nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Install PHP and dependencies
RUN apk add --no-cache php83 php83-fpm

# Create PHP-FPM config
RUN echo 'listen = 9000' >> /etc/php83/php-fpm.d/www.conf

# Test if PHP works
RUN php83 -v

# Start with error logging
CMD sh -c "echo 'Starting PHP-FPM...' && /usr/sbin/php-fpm83 -D && echo 'PHP-FPM started' && echo 'Starting nginx...' && nginx -g 'daemon off;'"