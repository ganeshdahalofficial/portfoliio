FROM nginx:alpine

# Install envsubst
RUN apk add --no-cache gettext

# Copy your website files
COPY . /usr/share/nginx/html/

# Create nginx config template for port 9000
RUN echo 'events { worker_connections 1024; }' > /etc/nginx/nginx.conf
RUN echo 'http { server { listen 9000; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } } }' >> /etc/nginx/nginx.conf

# Start nginx
CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]

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

# Copy your website files
COPY . /usr/share/nginx/html/

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

# Configure PHP-FPM to listen on port 9001
RUN echo 'listen = 9001' >> /etc/php83/php-fpm.d/www.conf

# Start both services
CMD sh -c "php-fpm83 -D && nginx -c /etc/nginx/nginx.conf -g 'daemon off;'"