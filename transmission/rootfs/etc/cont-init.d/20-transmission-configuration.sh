#!/usr/bin/with-contenv bashio
# ==============================================================================

declare CONFIG
declare authentication_required
declare username
declare password

if ! bashio::fs.directory_exists '/data/transmission'; then
  mkdir '/data/transmission'
fi

if ! bashio::fs.file_exists '/data/transmission/settings.json'; then
  echo "{}" > /data/transmission/settings.json
fi

CONFIG=$(</data/transmission/settings.json)

# Defaults
CONFIG=$(bashio::jq "${CONFIG}" ".\"incomplete-dir-enabled\"=false")
CONFIG=$(bashio::jq "${CONFIG}" ".\"download-dir\"=\"/media/Seagate/Downloads\"")
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-whitelist-enabled\"=false")
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-host-whitelist-enabled\"=false")
CONFIG=$(bashio::jq "${CONFIG}" ".\"bind-address-ipv4\"=\"0.0.0.0\"")

# Speed limits
CONFIG=$(bashio::jq "${CONFIG}" ".\"speed-limit-down-enabled\"=true")
CONFIG=$(bashio::jq "${CONFIG}" ".\"speed-limit-down\"=800")
CONFIG=$(bashio::jq "${CONFIG}" ".\"speed-limit-up-enabled\"=true")
CONFIG=$(bashio::jq "${CONFIG}" ".\"speed-limit-up\"=1")

# Alt speeds
CONFIG=$(bashio::jq "${CONFIG}" ".\"alt-speed-down\"=200")
CONFIG=$(bashio::jq "${CONFIG}" ".\"alt-speed-up\"=1")

# Ratio limits
CONFIG=$(bashio::jq "${CONFIG}" ".\"ratio-limit-enabled\"=true")
CONFIG=$(bashio::jq "${CONFIG}" ".\"ratio-limit\"=0")


authentication_required=$(bashio::config 'authentication_required')
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-authentication-required\"=${authentication_required}")


username=$(bashio::config 'username')
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-username\"=\"${username}\"")


password=$(bashio::config 'password')
CONFIG=$(bashio::jq "${CONFIG}" ".\"rpc-password\"=\"${password}\"")

echo "${CONFIG}" > /data/transmission/settings.json
