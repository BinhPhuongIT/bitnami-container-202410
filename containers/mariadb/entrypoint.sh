#!/bin/bash
set -e
source $BITNAMI_PREFIX/bitnami-utils.sh

print_welcome_page

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
  EXTRA_OPTIONS="$@"
  set -- mysqld.bin
fi

if [ ! "$(ls -A $BITNAMI_APP_VOL_PREFIX/conf)" ]; then
  generate_conf_files
fi

if [ "$1" = 'mysqld.bin' ]; then
  set -- $@ $PROGRAM_OPTIONS
  mkdir -p $BITNAMI_APP_DIR/tmp
  chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER $BITNAMI_APP_DIR/tmp || true

  if [ ! -d $BITNAMI_APP_VOL_PREFIX/data/mysql ]; then

    set -- "$@" --init-file=/tmp/init_mysql.sql

    initialize_database

    create_custom_database

    create_mysql_user

    print_app_credentials $BITNAMI_APP_NAME $MARIADB_USER `print_mysql_password` `print_mysql_database`
  else
    print_container_already_initialized $BITNAMI_APP_NAME
  fi

  chown -R $BITNAMI_APP_USER:$BITNAMI_APP_USER \
    $BITNAMI_APP_VOL_PREFIX/conf/ \
    $BITNAMI_APP_VOL_PREFIX/logs/ \
    $BITNAMI_APP_VOL_PREFIX/data/ || true
fi

exec "$@"
