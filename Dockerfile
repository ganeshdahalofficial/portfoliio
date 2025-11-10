FROM nginx:alpine
COPY . /usr/share/nginx/html/
RUN find /etc/nginx -name "*.conf" -type f
CMD nginx -g 'daemon off;'