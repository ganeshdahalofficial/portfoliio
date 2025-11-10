FROM nginx:alpine

# Install PHP, FPM, and dependencies
RUN apk add --no-cache \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-json \
    php83-openssl \
    php83-curl \
    php83-zlib \
    php83-xml \
    php83-phar \
    php83-intl \
    php83-dom \
    php83-xmlreader \
    php83-ctype \
    php83-session \
    php83-mbstring \
    php83-gd \
    gettext

# Copy your website files including .env
COPY . /usr/share/nginx/html/

# Fix PHP-FPM configuration
RUN echo 'listen = 127.0.0.1:9001' >> /etc/php83/php-fpm.d/www.conf
RUN echo 'listen.allowed_clients = 127.0.0.1' >> /etc/php83/php-fpm.d/www.conf
RUN echo 'pm.max_children = 5' >> /etc/php83/php-fpm.d/www.conf
RUN echo 'pm.start_servers = 2' >> /etc/php83/php-fpm.d/www.conf
RUN echo 'pm.min_spare_servers = 1' >> /etc/php83/php-fpm.d/www.conf
RUN echo 'pm.max_spare_servers = 3' >> /etc/php83/php-fpm.d/www.conf

# Create nginx config with PHP support
RUN echo 'events { worker_connections 1024; }' > /etc/nginx/nginx.conf
RUN echo 'http {' >> /etc/nginx/nginx.conf
RUN echo '    server {' >> /etc/nginx/nginx.conf
RUN echo '        listen 9000;' >> /etc/nginx/nginx.conf
RUN echo '        root /usr/share/nginx/html;' >> /etc/nginx/nginx.conf
RUN echo '        index index.html index.php;' >> /etc/nginx/nginx.conf
RUN echo '        location / {' >> /etc/nginx/nginx.conf
RUN echo '            try_files $uri $uri/ /index.html;' >> /etc/nginx/nginx.conf
RUN echo '        }' >> /etc/nginx/nginx.conf
RUN echo '        location ~ \.php$ {' >> /etc/nginx/nginx.conf
RUN echo '            fastcgi_pass 127.0.0.1:9001;' >> /etc/nginx/nginx.conf
RUN echo '            fastcgi_index index.php;' >> /etc/nginx/nginx.conf
RUN echo '            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> /etc/nginx/nginx.conf
RUN echo '            include fastcgi_params;' >> /etc/nginx/nginx.conf
RUN echo '        }' >> /etc/nginx/nginx.conf
RUN echo '    }' >> /etc/nginx/nginx.conf
RUN echo '}' >> /etc/nginx/nginx.conf

# Start both services with error logging
CMD sh -c "php-fpm83 -D && echo 'PHP-FPM started' && nginx -c /etc/nginx/nginx.conf -g 'daemon off;'"