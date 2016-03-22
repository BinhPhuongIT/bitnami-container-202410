#!/bin/bash
set -e

if [[ "$1" == "harpoon" && "$2" == "start" ]]; then
  status=`harpoon inspect $BITNAMI_APP_NAME`
  if [[ "$status" == *'"lifecycle": "unpacked"'* ]]; then
    # HACK: harpoon initialize should create the db directory
    mkdir -p $BITNAMI_APP_DIR/data/db
    chown -R $BITNAMI_APP_USER:root $BITNAMI_APP_DIR/data/db

    harpoon initialize $BITNAMI_APP_NAME \
      --username ${MONGODB_USER:-root} \
      --password ${MONGODB_PASSWORD:-password}
  fi

  chown -R $BITNAMI_APP_USER: $BITNAMI_APP_DIR/data || true
fi

exec /entrypoint.sh "$@"
