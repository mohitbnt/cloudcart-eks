#!/bin/sh
set -eu

: "${API_BASE:=/api}"

cat > /tmp/config.js <<EOF2
window.CLOUDCART_API_BASE = "${API_BASE}";
EOF2

exec nginx -g "daemon off;"