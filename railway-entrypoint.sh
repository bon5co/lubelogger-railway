#!/bin/sh
# LubeLogger for Railway: turn ADMIN_USERNAME / ADMIN_PASSWORD into the SHA256 hashes upstream reads,
# keep the cookie data-protection keys on the data volume, then start the stock binary.
set -eu

ADMIN_USERNAME="${ADMIN_USERNAME:-admin}"
if [ -z "${ADMIN_PASSWORD:-}" ]; then
  echo "railway-entrypoint: ADMIN_PASSWORD is empty; refusing to start with an open instance" >&2
  exit 1
fi

# upstream: lowercase hex SHA256 of the UTF-8 value, no salt, no newline (printf %s, never echo)
UserNameHash="$(printf %s "$ADMIN_USERNAME" | sha256sum | cut -d' ' -f1)"
UserPasswordHash="$(printf %s "$ADMIN_PASSWORD" | sha256sum | cut -d' ' -f1)"
export UserNameHash UserPasswordHash
export EnableAuth=true

# The login cookie is protected by keys written under /root/.aspnet; on a fresh container they are new, which
# logs every browser out on each redeploy. Put them on the volume.
mkdir -p /App/data/keys /root/.aspnet
rm -rf /root/.aspnet/DataProtection-Keys
ln -s /App/data/keys /root/.aspnet/DataProtection-Keys

if [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ] && [ -z "${LUBELOGGER_DOMAIN:-}" ]; then
  export LUBELOGGER_DOMAIN="https://${RAILWAY_PUBLIC_DOMAIN}"
fi

cd /App
exec "$@"
