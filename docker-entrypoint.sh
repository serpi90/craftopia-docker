#!/usr/bin/env bash
set -euo pipefail

echo "INSTALL_PATH: $INSTALL_PATH"

echo "Changing steam user id to (${USER_ID:=1000}) and group id (${GROUP_ID:=1000})"
sed -ri "s/^steam:x:[0-9]*/steam:x:$USER_ID/" /etc/passwd
sed -ri "s/^steam:x:[0-9]*/steam:x:$GROUP_ID/" /etc/group


echo "Setup directory structure and permissions"
mkdir -p "$INSTALL_PATH"
chown -R steam:steam "$INSTALL_PATH" /home/steam/

gosu steam:steam /server-entrypoint.sh
