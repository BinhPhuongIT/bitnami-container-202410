#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libldapclient.sh
. /opt/bitnami/scripts/libmariadbgalera.sh

# Load MariaDB environment variables
eval "$(mysql_env)"
# Load LDAP environment variables
eval "$(ldap_env)"

for _DIR in "$DB_TMP_DIR" "$DB_LOG_DIR" "$DB_CONF_DIR" "${DB_CONF_DIR}/bitnami" "$DB_VOLUME_DIR" "$DB_DATA_DIR"; do
    ensure_dir_exists "$_DIR"
done
chmod -R g+rwX "$DB_TMP_DIR" "$DB_LOG_DIR" "$DB_CONF_DIR" "${DB_CONF_DIR}/bitnami" "$DB_VOLUME_DIR" "$DB_DATA_DIR"

# LDAP permissions
ldap_configure_permissions
ldap_create_pam_config "mariadb"

# Redirect all logging to stdout
ln -sf /dev/stdout "$DB_LOG_DIR/mysqld.log"

# Fix to avoid issues detecting plugins in mysql_install_db
ln -sf "$DB_BASE_DIR/plugin" "$DB_BASE_DIR/lib/plugin"
