FROM nginx:alpine

# Copy files and show exactly what's being copied
COPY . /usr/share/nginx/html/
RUN echo "=== FILES IN CONTAINER ===" && \
    ls -la /usr/share/nginx/html/ && \
    echo "=== NGINX CONFIG FILES ===" && \
    find /etc/nginx -name "*.conf" -type f && \
    echo "=== DEFAULT NGINX CONF ===" && \
    cat /etc/nginx/conf.d/default.conf && \
    echo "=== MAIN NGINX CONF ===" && \
    cat /etc/nginx/nginx.conf | head -20 && \
    echo "=== NETWORK PORTS ===" && \
    netstat -tulpn || ss -tulpn || echo "netstat not available" && \
    echo "=== ENVIRONMENT VARIABLES ===" && \
    env

# Install extra tools for debugging
RUN apk add --no-cache curl net-tools

# Start nginx and keep it running with health checks
CMD sh -c " \
  echo '=== STARTING NGINX ===' && \
  nginx -t && \
  nginx -g 'daemon off;' & \
  sleep 3 && \
  echo '=== TESTING LOCALHOST ===' && \
  curl -v http://localhost:80/ || echo 'Localhost failed' && \
  echo '=== TESTING 127.0.0.1 ===' && \
  curl -v http://127.0.0.1:80/ || echo '127.0.0.1 failed' && \
  echo '=== CURRENT PROCESSES ===' && \
  ps aux && \
  echo '=== NGINX STATUS ===' && \
  ps aux | grep nginx || echo 'No nginx processes' && \
  echo '=== CONTAINER READY ===' && \
  tail -f /var/log/nginx/access.log \
"