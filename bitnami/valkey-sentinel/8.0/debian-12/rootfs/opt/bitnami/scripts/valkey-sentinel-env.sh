#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for valkey-sentinel

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
# shellcheck disable=SC1090,SC1091
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-valkey-sentinel}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
valkey_sentinel_env_vars=(
    VALKEY_SENTINEL_DATA_DIR
    VALKEY_SENTINEL_DISABLE_COMMANDS
    VALKEY_SENTINEL_DATABASE
    VALKEY_SENTINEL_AOF_ENABLED
    VALKEY_SENTINEL_HOST
    VALKEY_SENTINEL_MASTER_NAME
    VALKEY_SENTINEL_PORT_NUMBER
    VALKEY_SENTINEL_QUORUM
    VALKEY_SENTINEL_DOWN_AFTER_MILLISECONDS
    VALKEY_SENTINEL_FAILOVER_TIMEOUT
    VALKEY_SENTINEL_MASTER_REBOOT_DOWN_AFTER_PERIOD
    VALKEY_SENTINEL_RESOLVE_HOSTNAMES
    VALKEY_SENTINEL_ANNOUNCE_HOSTNAMES
    ALLOW_EMPTY_PASSWORD
    VALKEY_SENTINEL_PASSWORD
    VALKEY_MASTER_USER
    VALKEY_MASTER_PASSWORD
    VALKEY_SENTINEL_ANNOUNCE_IP
    VALKEY_SENTINEL_ANNOUNCE_PORT
    VALKEY_SENTINEL_TLS_ENABLED
    VALKEY_SENTINEL_TLS_PORT_NUMBER
    VALKEY_SENTINEL_TLS_CERT_FILE
    VALKEY_SENTINEL_TLS_KEY_FILE
    VALKEY_SENTINEL_TLS_CA_FILE
    VALKEY_SENTINEL_TLS_DH_PARAMS_FILE
    VALKEY_SENTINEL_TLS_AUTH_CLIENTS
    VALKEY_MASTER_HOST
    VALKEY_MASTER_PORT_NUMBER
    VALKEY_MASTER_SET
)
for env_var in "${valkey_sentinel_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        if [[ -r "${!file_env_var:-}" ]]; then
            export "${env_var}=$(< "${!file_env_var}")"
            unset "${file_env_var}"
        else
            warn "Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
        fi
    fi
done
unset valkey_sentinel_env_vars

# Paths
export VALKEY_SENTINEL_VOLUME_DIR="/bitnami/valkey-sentinel"
export VALKEY_SENTINEL_BASE_DIR="${BITNAMI_ROOT_DIR}/valkey-sentinel"
export VALKEY_SENTINEL_CONF_DIR="${VALKEY_SENTINEL_BASE_DIR}/etc"
export VALKEY_SENTINEL_DEFAULT_CONF_DIR="${VALKEY_SENTINEL_BASE_DIR}/etc.default"
export VALKEY_SENTINEL_DATA_DIR="${VALKEY_SENTINEL_DATA_DIR:-${VALKEY_SENTINEL_VOLUME_DIR}/data}"
export VALKEY_SENTINEL_MOUNTED_CONF_DIR="${VALKEY_SENTINEL_BASE_DIR}/mounted-etc"
export VALKEY_SENTINEL_CONF_FILE="${VALKEY_SENTINEL_CONF_DIR}/sentinel.conf"
export VALKEY_SENTINEL_LOG_DIR="${VALKEY_SENTINEL_BASE_DIR}/logs"
export VALKEY_SENTINEL_TMP_DIR="${VALKEY_SENTINEL_BASE_DIR}/tmp"
export VALKEY_SENTINEL_PID_FILE="${VALKEY_SENTINEL_TMP_DIR}/valkey-sentinel.pid"
export VALKEY_SENTINEL_BIN_DIR="${VALKEY_SENTINEL_BASE_DIR}/bin"
export PATH="${VALKEY_SENTINEL_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export VALKEY_SENTINEL_DAEMON_USER="valkey"
export VALKEY_SENTINEL_DAEMON_GROUP="valkey"

# Valkey Sentinel settings
export VALKEY_SENTINEL_DISABLE_COMMANDS="${VALKEY_SENTINEL_DISABLE_COMMANDS:-}"
export VALKEY_SENTINEL_DATABASE="${VALKEY_SENTINEL_DATABASE:-valkey}"
export VALKEY_SENTINEL_AOF_ENABLED="${VALKEY_SENTINEL_AOF_ENABLED:-yes}"
export VALKEY_SENTINEL_HOST="${VALKEY_SENTINEL_HOST:-}"
export VALKEY_SENTINEL_MASTER_NAME="${VALKEY_SENTINEL_MASTER_NAME:-}"
export VALKEY_SENTINEL_DEFAULT_PORT_NUMBER="26379" # only used at build time
export VALKEY_SENTINEL_PORT_NUMBER="${VALKEY_SENTINEL_PORT_NUMBER:-$VALKEY_SENTINEL_DEFAULT_PORT_NUMBER}"
export VALKEY_SENTINEL_QUORUM="${VALKEY_SENTINEL_QUORUM:-2}"
export VALKEY_SENTINEL_DOWN_AFTER_MILLISECONDS="${VALKEY_SENTINEL_DOWN_AFTER_MILLISECONDS:-60000}"
export VALKEY_SENTINEL_FAILOVER_TIMEOUT="${VALKEY_SENTINEL_FAILOVER_TIMEOUT:-180000}"
export VALKEY_SENTINEL_MASTER_REBOOT_DOWN_AFTER_PERIOD="${VALKEY_SENTINEL_MASTER_REBOOT_DOWN_AFTER_PERIOD:-0}"
export VALKEY_SENTINEL_RESOLVE_HOSTNAMES="${VALKEY_SENTINEL_RESOLVE_HOSTNAMES:-yes}"
export VALKEY_SENTINEL_ANNOUNCE_HOSTNAMES="${VALKEY_SENTINEL_ANNOUNCE_HOSTNAMES:-no}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export VALKEY_SENTINEL_PASSWORD="${VALKEY_SENTINEL_PASSWORD:-}"
export VALKEY_MASTER_USER="${VALKEY_MASTER_USER:-}"
export VALKEY_MASTER_PASSWORD="${VALKEY_MASTER_PASSWORD:-}"
export VALKEY_SENTINEL_ANNOUNCE_IP="${VALKEY_SENTINEL_ANNOUNCE_IP:-}"
export VALKEY_SENTINEL_ANNOUNCE_PORT="${VALKEY_SENTINEL_ANNOUNCE_PORT:-}"

# TLS settings
export VALKEY_SENTINEL_TLS_ENABLED="${VALKEY_SENTINEL_TLS_ENABLED:-no}"
export VALKEY_SENTINEL_TLS_PORT_NUMBER="${VALKEY_SENTINEL_TLS_PORT_NUMBER:-26379}"
export VALKEY_SENTINEL_TLS_CERT_FILE="${VALKEY_SENTINEL_TLS_CERT_FILE:-}"
export VALKEY_SENTINEL_TLS_KEY_FILE="${VALKEY_SENTINEL_TLS_KEY_FILE:-}"
export VALKEY_SENTINEL_TLS_CA_FILE="${VALKEY_SENTINEL_TLS_CA_FILE:-}"
export VALKEY_SENTINEL_TLS_DH_PARAMS_FILE="${VALKEY_SENTINEL_TLS_DH_PARAMS_FILE:-}"
export VALKEY_SENTINEL_TLS_AUTH_CLIENTS="${VALKEY_SENTINEL_TLS_AUTH_CLIENTS:-yes}"

# Valkey Master settings
export VALKEY_MASTER_HOST="${VALKEY_MASTER_HOST:-valkey}"
export VALKEY_MASTER_PORT_NUMBER="${VALKEY_MASTER_PORT_NUMBER:-6379}"
export VALKEY_MASTER_SET="${VALKEY_MASTER_SET:-mymaster}"

# Custom environment variables may be defined below
