ARG PHP_VERSION=8.3

FROM litespeedtech/openlitespeed:latest

ARG PHP_VERSION

RUN PHP_PREFIX=$(echo "$PHP_VERSION" | tr -d '.') && \
    apt-get update && apt-get install -y --no-install-recommends \
    inotify-tools \
    lsphp${PHP_PREFIX} \
    lsphp${PHP_PREFIX}-common \
    lsphp${PHP_PREFIX}-curl \
    lsphp${PHP_PREFIX}-intl \
    lsphp${PHP_PREFIX}-mysql \
    lsphp${PHP_PREFIX}-imagick \
    lsphp${PHP_PREFIX}-redis \
    lsphp${PHP_PREFIX}-sqlite3 \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY conf/ /tmp/php-conf/
RUN PHP_PREFIX=$(echo "$PHP_VERSION" | tr -d '.') && \
    PHP_DIR=$(ls -d /usr/local/lsws/lsphp${PHP_PREFIX}/etc/php/*/mods-available) && \
    cp /tmp/php-conf/php.ini "${PHP_DIR}/99-custom.ini" && \
    cp /tmp/php-conf/opcache.ini "${PHP_DIR}/99-opcache.ini" && \
    rm -rf /tmp/php-conf
COPY scripts/watch-htaccess.sh /watch-htaccess.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /watch-htaccess.sh /docker-entrypoint.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

STOPSIGNAL SIGTERM

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/lsws/bin/lswsctrl", "run"]
