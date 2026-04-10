# OpenLiteSpeed WordPress Docker Image

Production-ready Docker image for [OpenLiteSpeed](https://openlitespeed.org/) with LSPHP, bundling all PHP extensions required by WordPress, WooCommerce, and SQLite.

Published to GitHub Container Registry at **`ghcr.io/aprakasa/ols`**.

## Tags

| Tag | Description |
|-----|-------------|
| `ghcr.io/aprakasa/ols:latest` | Latest build (PHP 8.5) |
| `ghcr.io/aprakasa/ols:8.3` | PHP 8.3 |
| `ghcr.io/aprakasa/ols:8.4` | PHP 8.4 |
| `ghcr.io/aprakasa/ols:8.5` | PHP 8.5 |

## Usage

```yaml
services:
  ols:
    image: ghcr.io/aprakasa/ols:8.3
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./html:/var/www/vhosts/localhost/html/
```

## PHP Extensions

mysqli, pdo_mysql, mbstring, xml, curl, zip, gd, intl, imagick, bcmath, redis, sqlite3, pdo_sqlite, sockets, opcache.

## .htaccess Auto-Reload

OLS caches `.htaccess` and only re-reads on restart. This image includes a background watcher that detects `.htaccess` changes and triggers a graceful OLS reload.

| Environment Variable | Default | Description |
|---------------------|---------|-------------|
| `HTACCESS_WATCH_ENABLED` | `true` | Set to `false` to disable |
| `HTACCESS_WATCH_PATH` | `/var/www/vhosts/localhost/html/` | Path to monitor |
| `HTACCESS_WATCH_DEBOUNCE` | `1` | Debounce window in seconds |

## License

[MIT](LICENSE)
