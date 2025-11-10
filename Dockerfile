FROM nginx:alpine

# Copy files
COPY . /usr/share/nginx/html/

# List what was copied
RUN ls -la /usr/share/nginx/html/

# Use port 8080 (Railway's standard)
CMD sed -i 's/listen.*80/listen 8080/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'