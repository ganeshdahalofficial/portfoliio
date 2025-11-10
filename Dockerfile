FROM nginx:alpine

# Install envsubst
RUN apk add --no-cache gettext

# Copy your website files
COPY . /usr/share/nginx/html/

# Create nginx config template
RUN echo 'events { worker_connections 1024; }' > /etc/nginx/nginx.conf
RUN echo 'http { server { listen $PORT; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } } }' >> /etc/nginx/nginx.conf

# Use envsubst to replace PORT variable
CMD ["sh", "-c", "envsubst < /etc/nginx/nginx.conf > /tmp/nginx.conf && nginx -c /tmp/nginx.conf -g 'daemon off;'"]