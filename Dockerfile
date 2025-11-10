FROM nginx:alpine

# Copy your website files
COPY . /usr/share/nginx/html/

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Install envsubst to handle environment variables
RUN apk add --no-cache gettext

# Substitute environment variables in nginx config
CMD envsubst '${PORT}' < /etc/nginx/nginx.conf > /etc/nginx/nginx-substituted.conf && \
    nginx -c /etc/nginx/nginx-substituted.conf -g 'daemon off;'