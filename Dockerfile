FROM nginx:alpine

# Copy your website files
COPY . /usr/share/nginx/html/

# Debug: Show the nginx config
RUN cat /etc/nginx/nginx.conf

# Start nginx
CMD ["nginx", "-g", "daemon off;"]