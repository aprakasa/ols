ARG OLS_IMAGE=litespeedtech/openlitespeed:1.8.5-lsphp83
ARG PHP_VERSION=8.3

FROM ${OLS_IMAGE}

ARG PHP_VERSION

LABEL org.opencontainers.image.title="aprakasa/ols" \
      org.opencontainers.image.description="Production-ready OpenLiteSpeed with LSPHP for WordPress" \
      org.opencontainers.image.url="https://github.com/aprakasa/ols" \
      org.opencontainers.image.source="https://github.com/aprakasa/ols" \
      org.opencontainers.image.vendor="aprakasa" \
      org.opencontainers.image.licenses="MIT"

COPY conf/ /tmp/php-conf/

RUN PHP_PREFIX=$(echo "$PHP_VERSION" | tr -d '.') && \
    apt-get update && apt-get install -y --no-install-recommends \
    inotify-tools \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && PHP_DIR=$(ls -d /usr/local/lsws/lsphp${PHP_PREFIX}/etc/php/*/mods-available) \
    && cp /tmp/php-conf/php.ini "${PHP_DIR}/99-custom.ini" \
    && cp /tmp/php-conf/opcache.ini "${PHP_DIR}/99-opcache.ini" \
    && rm -rf /tmp/php-conf

COPY scripts/watch-htaccess.sh /watch-htaccess.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /watch-htaccess.sh /docker-entrypoint.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

STOPSIGNAL SIGTERM

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/lsws/bin/lswsctrl", "run"]
