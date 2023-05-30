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
rpcuser=${ECOIN_RPCUSER:-emarkrpc}
rpcpassword=${ECOIN_RPCPASSWORD}
rpcclienttimeout=${ECOIN_RPCCLIENTTIMEOUT:-30}
EOF
echo "Created new configuration at ${ECOIN_CONF}"
fi

if [ $# -eq 0 ]; then
  /ecoin/canada-ecoin/src/canadaecoind -rpcbind=:4444 -rpcallowip=* -printtoconsole=1
else
  exec "$@"
fi
