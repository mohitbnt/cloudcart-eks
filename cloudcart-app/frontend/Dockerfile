FROM nginxinc/nginx-unprivileged:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /usr/share/nginx/html/index.html
COPY css/ /usr/share/nginx/html/css/
COPY js/ /usr/share/nginx/html/js/
COPY --chmod=0755 docker-entrypoint.sh /docker-entrypoint.sh

USER root
RUN ln -s /tmp/config.js /usr/share/nginx/html/config.js
USER 101

EXPOSE 8080
ENTRYPOINT ["/docker-entrypoint.sh"]