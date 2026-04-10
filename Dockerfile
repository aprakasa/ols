ARG PHP_VERSION=8.3

FROM litespeedtech/openlitespeed:latest

ARG PHP_VERSION

RUN PHP_PREFIX=$(echo "$PHP_VERSION" | tr -d '.') && \
    apt-get update && apt-get install -y --no-install-recommends \
    inotify-tools \
    lsphp${PHP_PREFIX}-mysql \
    lsphp${PHP_PREFIX}-mbstring \
    lsphp${PHP_PREFIX}-xml \
    lsphp${PHP_PREFIX}-curl \
    lsphp${PHP_PREFIX}-zip \
    lsphp${PHP_PREFIX}-gd \
    lsphp${PHP_PREFIX}-intl \
    lsphp${PHP_PREFIX}-imagick \
    lsphp${PHP_PREFIX}-bcmath \
    lsphp${PHP_PREFIX}-redis \
    lsphp${PHP_PREFIX}-sqlite3 \
    lsphp${PHP_PREFIX}-pdo \
    lsphp${PHP_PREFIX}-pdo-sqlite \
    lsphp${PHP_PREFIX}-sockets \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY conf/php.ini /usr/local/lsws/lsphp*/etc/php/*/mods-available/99-custom.ini
COPY conf/opcache.ini /usr/local/lsws/lsphp*/etc/php/*/mods-available/99-opcache.ini
COPY scripts/watch-htaccess.sh /watch-htaccess.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /watch-htaccess.sh /docker-entrypoint.sh

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

STOPSIGNAL SIGTERM

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/lsws/bin/lswsctrl", "run"]
