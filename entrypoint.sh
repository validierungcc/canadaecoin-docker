#!/bin/bash

set -meuo pipefail

ECOIN_DIR=/ecoin/.canadaecoin/
ECOIN_CONF=/ecoin/.canadaecoin/canadaecoin.conf

if [ -z "${ECOIN_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  ECOIN_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${ECOIN_CONF}" ]; then
  tee -a >${ECOIN_CONF} <<EOF
server=1
rpcuser=${ECOIN_RPCUSER:-canadaecoinrpc}
rpcpassword=${ECOIN_RPCPASSWORD}
rpcclienttimeout=${ECOIN_RPCCLIENTTIMEOUT:-30}
EOF
echo "Created new configuration at ${ECOIN_CONF}"
fi

if [ $# -eq 0 ]; then
   /usr/local/bin/canadaecoind -rpcbind=0.0.0.0 -rpcport=34330 -rpcallowip=0.0.0.0/0 -printtoconsole=1
else
  exec "$@"
fi
