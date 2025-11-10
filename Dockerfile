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