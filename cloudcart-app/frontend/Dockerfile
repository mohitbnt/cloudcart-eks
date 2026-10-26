FROM nginx:1.30.6-alpine

# Fix CVE-2026-31789 by upgrading OpenSSL libraries to 3.3.7-r0 or higher
RUN apk update && apk add --no-cache "libcrypto3>=3.3.7-r0" "libssl3>=3.3.7-r0"

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY css/ /usr/share/nginx/html/css/
COPY js/ /usr/share/nginx/html/js/
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/docker-entrypoint.sh"]