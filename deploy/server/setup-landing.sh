#!/usr/bin/env bash
# Prepares the shared server for landing deploys from GitHub Actions. Run once
# as root, after the server's setup.sh:
#   sudo bash setup-landing.sh <file with the public deploy key>
# - rsync: GitHub Actions uploads the built site with it
# - user "landing" owns the site folder; its key may only rsync files into that
#   folder (rrsync), no shell, no sudo, no docker
# - nginx serves volki-lzkv.ru from that folder instead of the placeholder
# Touches only the landing's own user, folder and nginx site. Safe to run again.
set -euo pipefail

DEPLOY_USER=landing
DOMAIN=volki-lzkv.ru
SITE_DIR=/var/www/$DOMAIN
SRC=$(cd "$(dirname "$0")" && pwd)

step() { printf '\n==> %s\n' "$*"; }

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo bash $0 <file with the public deploy key>" >&2
  exit 1
fi
KEY_FILE=${1:?Usage: sudo bash setup-landing.sh <file with the public deploy key>}
site=/etc/nginx/sites-available/$DOMAIN
if [ ! -e "$site" ]; then
  echo "$site not found: run the server's setup.sh first" >&2
  exit 1
fi

step "Installing rsync"
if ! command -v rsync >/dev/null || ! command -v rrsync >/dev/null; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y rsync
fi
rrsync=$(command -v rrsync)
# sed, not head: head closes the pipe early and pipefail stops the script.
rsync --version | sed -n 1p

step "User $DEPLOY_USER"
if id "$DEPLOY_USER" >/dev/null 2>&1; then
  echo "Already exists"
else
  # No password: the server lets in by SSH key only.
  useradd --create-home --shell /bin/bash "$DEPLOY_USER"
fi
id "$DEPLOY_USER"

step "Site folder $SITE_DIR"
install -d -m 0755 -o "$DEPLOY_USER" -g "$DEPLOY_USER" "$SITE_DIR"
# Until the first deploy the domain keeps showing the placeholder.
if [ ! -e "$SITE_DIR/index.html" ]; then
  install -m 0644 -o "$DEPLOY_USER" -g "$DEPLOY_USER" /var/www/stub/index.html "$SITE_DIR/index.html"
fi

step "SSH key of $DEPLOY_USER"
ssh-keygen -l -f "$KEY_FILE"
home=$(getent passwd "$DEPLOY_USER" | cut -d: -f6)
install -d -m 0700 -o "$DEPLOY_USER" -g "$DEPLOY_USER" "$home/.ssh"
# "restrict": no forwarding and no terminal. The forced command runs rrsync,
# which lets the key only write into the site folder.
keys=$(mktemp)
grep -vE '^\s*(#|$)' "$KEY_FILE" | sed "s|^|restrict,command=\"$rrsync -wo $SITE_DIR\" |" >"$keys"
install -m 0600 -o "$DEPLOY_USER" -g "$DEPLOY_USER" "$keys" "$home/.ssh/authorized_keys"
rm -f "$keys"

step "nginx: $DOMAIN is served from $SITE_DIR"
backup=$(mktemp)
cp -p "$site" "$backup"
install -m 0644 "$SRC/nginx/$DOMAIN" "$site"
ln -sf "$site" "/etc/nginx/sites-enabled/$DOMAIN"
if ! nginx -t; then
  cp -p "$backup" "$site"
  echo "nginx rejected the new config, the old one is back in place" >&2
  exit 1
fi
rm -f "$backup"
systemctl reload nginx

step "Check"
curl -fsS -o /dev/null --resolve "$DOMAIN:443:127.0.0.1" \
  -w "https://$DOMAIN/ -> %{http_code}\n" "https://$DOMAIN/"

step "Ready: GitHub Actions can deploy the landing as $DEPLOY_USER"
