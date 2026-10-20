# Landing: static files that GitHub Actions uploads with rsync
# (.github/workflows/deploy.yml in the personal-crm-landing repo).
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name volki-lzkv.ru;
    include snippets/volki-lzkv-tls.conf;

    root /var/www/volki-lzkv.ru;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    # Astro puts a content hash into these file names, so a file never changes.
    location /_astro/ {
        add_header Cache-Control "public, max-age=31536000, immutable";
    }
}
