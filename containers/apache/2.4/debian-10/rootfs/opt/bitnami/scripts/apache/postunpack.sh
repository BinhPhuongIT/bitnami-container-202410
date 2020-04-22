#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libapache.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

########################
# Sets up the default Bitnami configuration
# Globals:
#   APACHE_*
# Arguments:
#   None
# Returns:
#   None
#########################
apache_setup_bitnami_config() {
    local -r template_dir="${BITNAMI_ROOT_DIR}/scripts/apache/bitnami-templates"

    # Enable Apache modules
    modules_to_enable="mod_version mod_socache_shmcb mod_negotiation mod_ssl mod_slotmem_shm mod_deflate mod_rewrite mod_proxy.* mod_status"
    for module in $modules_to_enable; do
        apache_enable_module "$module"
    done

    # Disable Apache modules
    modules_to_disable="mod_proxy_hcheck mod_http2"
    for module in $modules_to_disable; do
        apache_disable_module "$module"
    done

    apache_enable_configuration_entry "Include conf/extra/httpd-default.conf"

    # Bitnami customizations
    render-template "${template_dir}/bitnami.conf.tpl" > "${APACHE_CONF_DIR}/bitnami/bitnami.conf"
    render-template "${template_dir}/bitnami-ssl.conf.tpl" > "${APACHE_CONF_DIR}/bitnami/bitnami-ssl.conf"

    # Add new configuration only once, to avoid a second postunpack run breaking Apache
    if ! grep -q "${APACHE_CONF_DIR}/bitnami/bitnami.conf" "$APACHE_CONF_FILE"; then
        cat >>"$APACHE_CONF_FILE" <<EOF
PidFile "${APACHE_PID_FILE}"
TraceEnable Off
Include ${APACHE_CONF_DIR}/deflate.conf
IncludeOptional ${APACHE_VHOSTS_DIR}/*.conf
Include ${APACHE_CONF_DIR}/bitnami/bitnami.conf
EOF
    fi

    # Configure the default ports since the container is non root by default
    apache_configure_http_port "$APACHE_DEFAULT_HTTP_PORT_NUMBER"
    apache_configure_https_port "$APACHE_DEFAULT_HTTPS_PORT_NUMBER"

    # Patch the HTTPoxy vulnerability - see: https://docs.bitnami.com/general/security/security-2016-07-18/
    apache_patch_httpoxy_vulnerability

    # Remove unneeded directories that come with the tarball
    rm -rf "/opt/bitnami/certs" "/opt/bitnami/conf"
}

########################
# Patches the HTTPoxy vulnerability - see: https://docs.bitnami.com/general/security/security-2016-07-18/
# Globals:
#   APACHE_CONF_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
apache_patch_httpoxy_vulnerability() {
    # Apache HTTPD includes the HTTPoxy fix since 2016, so we only add it if not present
    if ! grep -q "RequestHeader unset Proxy" "$APACHE_CONF_FILE"; then
        cat >>"$APACHE_CONF_FILE" <<EOF
<IfModule mod_headers.c>
  RequestHeader unset Proxy
</IfModule>
EOF
    fi
}

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh

apache_setup_bitnami_config

# Ensure non-root user has write permissions on a set of directories
for dir in "$APACHE_TMP_DIR" "$APACHE_CONF_DIR" "$APACHE_LOGS_DIR" "$APACHE_VHOSTS_DIR" "$APACHE_HTACCESS_DIR" "$APACHE_HTDOCS_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

ln -sf "/dev/stdout" "${APACHE_LOGS_DIR}/access_log"
ln -sf "/dev/stderr" "${APACHE_LOGS_DIR}/error_log"
