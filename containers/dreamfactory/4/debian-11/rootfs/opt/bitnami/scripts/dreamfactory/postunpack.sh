#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load DreamFactory environment
. /opt/bitnami/scripts/dreamfactory-env.sh

# Load PHP environment for 'php_conf_set' (after 'dreamfactory-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libdreamfactory.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment (after DreamFactory environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure the DreamFactory base directory exists and has proper permissions
info "Configuring file permissions for DreamFactory"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$DREAMFACTORY_BASE_DIR" "$DREAMFACTORY_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Configure required PHP options for application to work properly, based on build-time defaults
# Based on https://www.dreamfactory.com/developers/scripts/increasing-the-php-memory-limit-setting
info "Configuring default PHP options for DreamFactory"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"
# Enable additional PHP modules for additional DB support
# See https://wiki.dreamfactory.com/DreamFactory/Features/Database
php_conf_set extension "mongodb"
php_conf_set extension "pdo_dblib"

# Enable default web server configuration for DreamFactory
info "Creating default web server configuration for DreamFactory"
web_server_validate
ensure_web_server_app_configuration_exists "dreamfactory" --type php --document-root "${DREAMFACTORY_BASE_DIR}/public"
