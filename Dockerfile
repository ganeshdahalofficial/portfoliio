FROM nginx:alpine

# Copy your website files
COPY . /usr/share/nginx/html/

# Replace the default nginx config entirely
RUN rm /etc/nginx/conf.d/default.conf

# Create a simple nginx config that uses PORT environment variable
RUN echo 'events { worker_connections 1024; }' > /etc/nginx/nginx.conf
RUN echo 'http { server { listen $PORT; root /usr/share/nginx/html; index index.html; location / { try_files $uri $uri/ /index.html; } } }' >> /etc/nginx/nginx.conf

# Use envsubst to replace $PORT with actual port
CMD envsubst '\$PORT' < /etc/nginx/nginx.conf > /tmp/nginx.conf && nginx -c /tmp/nginx.conf -g 'daemon off;'