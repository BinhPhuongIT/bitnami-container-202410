#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for kibana

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
export MODULE="${MODULE:-kibana}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
kibana_env_vars=(
    KIBANA_ELASTICSEARCH_URL
    KIBANA_ELASTICSEARCH_PORT_NUMBER
    KIBANA_HOST
    KIBANA_PORT_NUMBER
    KIBANA_WAIT_READY_MAX_RETRIES
    KIBANA_INITSCRIPTS_START_SERVER
    KIBANA_FORCE_INITSCRIPTS
    KIBANA_DISABLE_STRICT_CSP
    KIBANA_CERTS_DIR
    KIBANA_SERVER_ENABLE_TLS
    KIBANA_SERVER_KEYSTORE_LOCATION
    KIBANA_SERVER_KEYSTORE_PASSWORD
    KIBANA_SERVER_TLS_USE_PEM
    KIBANA_SERVER_CERT_LOCATION
    KIBANA_SERVER_KEY_LOCATION
    KIBANA_SERVER_KEY_PASSWORD
    KIBANA_PASSWORD
    KIBANA_ELASTICSEARCH_ENABLE_TLS
    KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE
    KIBANA_ELASTICSEARCH_TRUSTSTORE_LOCATION
    KIBANA_ELASTICSEARCH_TRUSTSTORE_PASSWORD
    KIBANA_ELASTICSEARCH_TLS_USE_PEM
    KIBANA_ELASTICSEARCH_CA_CERT_LOCATION
    KIBANA_DISABLE_STRICT_CSP
    KIBANA_CREATE_USER
    KIBANA_ELASTICSEARCH_PASSWORD
    KIBANA_SERVER_PUBLICBASEURL
    KIBANA_XPACK_SECURITY_ENCRYPTIONKEY
    KIBANA_XPACK_REPORTING_ENCRYPTIONKEY
    KIBANA_NEWSFEED_ENABLED
    KIBANA_ELASTICSEARCH_REQUESTTIMEOUT
    ELASTICSEARCH_URL
    KIBANA_ELASTICSEARCH_PORT_NUMBER
    KIBANA_ELASTICSEARCH_PORT
    KIBANA_PORT_NUMBER
    KIBANA_INITSCRIPTS_MAX_RETRIES
)
for env_var in "${kibana_env_vars[@]}"; do
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
unset kibana_env_vars
export SERVER_FLAVOR="kibana"

# Paths
export BITNAMI_VOLUME_DIR="/bitnami"
export KIBANA_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/kibana"
export SERVER_VOLUME_DIR="$KIBANA_VOLUME_DIR"
export KIBANA_BASE_DIR="${BITNAMI_ROOT_DIR}/kibana"
export SERVER_BASE_DIR="$KIBANA_BASE_DIR"
export KIBANA_CONF_DIR="${SERVER_BASE_DIR}/config"
export SERVER_CONF_DIR="$KIBANA_CONF_DIR"
export KIBANA_DEFAULT_CONF_DIR="${SERVER_BASE_DIR}/config.default"
export SERVER_DEFAULT_CONF_DIR="$KIBANA_DEFAULT_CONF_DIR"
export KIBANA_LOGS_DIR="${SERVER_BASE_DIR}/logs"
export SERVER_LOGS_DIR="$KIBANA_LOGS_DIR"
export KIBANA_TMP_DIR="${SERVER_BASE_DIR}/tmp"
export SERVER_TMP_DIR="$KIBANA_TMP_DIR"
export KIBANA_BIN_DIR="${SERVER_BASE_DIR}/bin"
export SERVER_BIN_DIR="$KIBANA_BIN_DIR"
export KIBANA_PLUGINS_DIR="${SERVER_BASE_DIR}/plugins"
export SERVER_PLUGINS_DIR="$KIBANA_PLUGINS_DIR"
export KIBANA_DEFAULT_PLUGINS_DIR="${SERVER_BASE_DIR}/plugins.default"
export SERVER_DEFAULT_PLUGINS_DIR="$KIBANA_DEFAULT_PLUGINS_DIR"
export KIBANA_DATA_DIR="${SERVER_VOLUME_DIR}/data"
export SERVER_DATA_DIR="$KIBANA_DATA_DIR"
export KIBANA_MOUNTED_CONF_DIR="${SERVER_VOLUME_DIR}/conf"
export SERVER_MOUNTED_CONF_DIR="$KIBANA_MOUNTED_CONF_DIR"
export KIBANA_CONF_FILE="${SERVER_CONF_DIR}/kibana.yml"
export SERVER_CONF_FILE="$KIBANA_CONF_FILE"
export KIBANA_LOG_FILE="${SERVER_LOGS_DIR}/kibana.log"
export SERVER_LOG_FILE="$KIBANA_LOG_FILE"
export KIBANA_PID_FILE="${SERVER_TMP_DIR}/kibana.pid"
export SERVER_PID_FILE="$KIBANA_PID_FILE"
export KIBANA_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export SERVER_INITSCRIPTS_DIR="$KIBANA_INITSCRIPTS_DIR"

# System users (when running with a privileged user)
export KIBANA_DAEMON_USER="kibana"
export SERVER_DAEMON_USER="$KIBANA_DAEMON_USER"
export KIBANA_DAEMON_GROUP="kibana"
export SERVER_DAEMON_GROUP="$KIBANA_DAEMON_GROUP"

# Kibana configuration
KIBANA_ELASTICSEARCH_URL="${KIBANA_ELASTICSEARCH_URL:-"${ELASTICSEARCH_URL:-}"}"
export KIBANA_ELASTICSEARCH_URL="${KIBANA_ELASTICSEARCH_URL:-elasticsearch}"
export SERVER_DB_URL="$KIBANA_ELASTICSEARCH_URL"
KIBANA_ELASTICSEARCH_PORT_NUMBER="${KIBANA_ELASTICSEARCH_PORT_NUMBER:-"${KIBANA_ELASTICSEARCH_PORT_NUMBER:-}"}"
KIBANA_ELASTICSEARCH_PORT_NUMBER="${KIBANA_ELASTICSEARCH_PORT_NUMBER:-"${KIBANA_ELASTICSEARCH_PORT:-}"}"
KIBANA_ELASTICSEARCH_PORT_NUMBER="${KIBANA_ELASTICSEARCH_PORT_NUMBER:-"${KIBANA_PORT_NUMBER:-}"}"
export KIBANA_ELASTICSEARCH_PORT_NUMBER="${KIBANA_ELASTICSEARCH_PORT_NUMBER:-9200}"
export SERVER_DB_PORT_NUMBER="$KIBANA_ELASTICSEARCH_PORT_NUMBER"
export KIBANA_HOST="${KIBANA_HOST:-0.0.0.0}"
export SERVER_HOST="$KIBANA_HOST"
export KIBANA_PORT_NUMBER="${KIBANA_PORT_NUMBER:-5601}"
export SERVER_PORT_NUMBER="$KIBANA_PORT_NUMBER"
KIBANA_WAIT_READY_MAX_RETRIES="${KIBANA_WAIT_READY_MAX_RETRIES:-"${KIBANA_INITSCRIPTS_MAX_RETRIES:-}"}"
export KIBANA_WAIT_READY_MAX_RETRIES="${KIBANA_WAIT_READY_MAX_RETRIES:-30}"
export SERVER_WAIT_READY_MAX_RETRIES="$KIBANA_WAIT_READY_MAX_RETRIES"
export KIBANA_INITSCRIPTS_START_SERVER="${KIBANA_INITSCRIPTS_START_SERVER:-yes}"
export SERVER_INITSCRIPTS_START_SERVER="$KIBANA_INITSCRIPTS_START_SERVER"
export KIBANA_FORCE_INITSCRIPTS="${KIBANA_FORCE_INITSCRIPTS:-no}"
export SERVER_FORCE_INITSCRIPTS="$KIBANA_FORCE_INITSCRIPTS"
export KIBANA_DISABLE_STRICT_CSP="${KIBANA_DISABLE_STRICT_CSP:-no}"
export SERVER_DISABLE_STRICT_CSP="$KIBANA_DISABLE_STRICT_CSP"

# Kibana server SSL/TLS configuration
export KIBANA_CERTS_DIR="${KIBANA_CERTS_DIR:-${SERVER_CONF_DIR}/certs}"
export SERVER_CERTS_DIR="$KIBANA_CERTS_DIR"
export KIBANA_SERVER_ENABLE_TLS="${KIBANA_SERVER_ENABLE_TLS:-false}"
export SERVER_ENABLE_TLS="$KIBANA_SERVER_ENABLE_TLS"
export KIBANA_SERVER_KEYSTORE_LOCATION="${KIBANA_SERVER_KEYSTORE_LOCATION:-${SERVER_CERTS_DIR}/server/kibana.keystore.p12}"
export SERVER_KEYSTORE_LOCATION="$KIBANA_SERVER_KEYSTORE_LOCATION"
export KIBANA_SERVER_KEYSTORE_PASSWORD="${KIBANA_SERVER_KEYSTORE_PASSWORD:-}"
export SERVER_KEYSTORE_PASSWORD="$KIBANA_SERVER_KEYSTORE_PASSWORD"
export KIBANA_SERVER_TLS_USE_PEM="${KIBANA_SERVER_TLS_USE_PEM:-false}"
export SERVER_TLS_USE_PEM="$KIBANA_SERVER_TLS_USE_PEM"
export KIBANA_SERVER_CERT_LOCATION="${KIBANA_SERVER_CERT_LOCATION:-${SERVER_CERTS_DIR}/server/tls.crt}"
export SERVER_CERT_LOCATION="$KIBANA_SERVER_CERT_LOCATION"
export KIBANA_SERVER_KEY_LOCATION="${KIBANA_SERVER_KEY_LOCATION:-${SERVER_CERTS_DIR}/server/tls.key}"
export SERVER_KEY_LOCATION="$KIBANA_SERVER_KEY_LOCATION"
export KIBANA_SERVER_KEY_PASSWORD="${KIBANA_SERVER_KEY_PASSWORD:-}"
export SERVER_KEY_PASSWORD="$KIBANA_SERVER_KEY_PASSWORD"

# Elasticsearch Security configuration
export KIBANA_PASSWORD="${KIBANA_PASSWORD:-}"
export SERVER_PASSWORD="$KIBANA_PASSWORD"
export KIBANA_ELASTICSEARCH_ENABLE_TLS="${KIBANA_ELASTICSEARCH_ENABLE_TLS:-false}"
export SERVER_DB_ENABLE_TLS="$KIBANA_ELASTICSEARCH_ENABLE_TLS"
export KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE="${KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE:-full}"
export SERVER_DB_TLS_VERIFICATION_MODE="$KIBANA_ELASTICSEARCH_TLS_VERIFICATION_MODE"
export KIBANA_ELASTICSEARCH_TRUSTSTORE_LOCATION="${KIBANA_ELASTICSEARCH_TRUSTSTORE_LOCATION:-${SERVER_CERTS_DIR}/elasticsearch/elasticsearch.truststore.p12}"
export SERVER_DB_TRUSTSTORE_LOCATION="$KIBANA_ELASTICSEARCH_TRUSTSTORE_LOCATION"
export KIBANA_ELASTICSEARCH_TRUSTSTORE_PASSWORD="${KIBANA_ELASTICSEARCH_TRUSTSTORE_PASSWORD:-}"
export SERVER_DB_TRUSTSTORE_PASSWORD="$KIBANA_ELASTICSEARCH_TRUSTSTORE_PASSWORD"
export KIBANA_ELASTICSEARCH_TLS_USE_PEM="${KIBANA_ELASTICSEARCH_TLS_USE_PEM:-false}"
export SERVER_DB_TLS_USE_PEM="$KIBANA_ELASTICSEARCH_TLS_USE_PEM"
export KIBANA_ELASTICSEARCH_CA_CERT_LOCATION="${KIBANA_ELASTICSEARCH_CA_CERT_LOCATION:-${SERVER_CERTS_DIR}/elasticsearch/ca.crt}"
export SERVER_DB_CA_CERT_LOCATION="$KIBANA_ELASTICSEARCH_CA_CERT_LOCATION"
export KIBANA_DISABLE_STRICT_CSP="${KIBANA_DISABLE_STRICT_CSP:-no}"
export KIBANA_CREATE_USER="${KIBANA_CREATE_USER:-false}"
export KIBANA_ELASTICSEARCH_PASSWORD="${KIBANA_ELASTICSEARCH_PASSWORD:-}"
export KIBANA_SERVER_PUBLICBASEURL="${KIBANA_SERVER_PUBLICBASEURL:-}"
export KIBANA_XPACK_SECURITY_ENCRYPTIONKEY="${KIBANA_XPACK_SECURITY_ENCRYPTIONKEY:-}"
export KIBANA_XPACK_REPORTING_ENCRYPTIONKEY="${KIBANA_XPACK_REPORTING_ENCRYPTIONKEY:-}"
export KIBANA_NEWSFEED_ENABLED="${KIBANA_NEWSFEED_ENABLED:-true}"
export KIBANA_ELASTICSEARCH_REQUESTTIMEOUT="${KIBANA_ELASTICSEARCH_REQUESTTIMEOUT:-30000}"

# Custom environment variables may be defined below
