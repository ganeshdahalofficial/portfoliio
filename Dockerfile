FROM nginx:alpine
COPY . /usr/share/nginx/html/
RUN ls -la /usr/share/nginx/html/