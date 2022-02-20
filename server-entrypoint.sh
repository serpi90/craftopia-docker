#!/usr/bin/env bash
set -euxo pipefail

cd "$INSTALL_PATH"

echo "Update SteamCMD and verify latest version"
steamcmd +quit

echo "Install or update Craftopia"
# shellcheck disable=SC2086
steamcmd \
	+force_install_dir "$INSTALL_PATH" \
	+login anonymous \
	+app_update 1670340 ${STEAM_BETA:-} validate \
	+quit

echo "Start server"

./Craftopia.x86_64 -batchmode -showlogs