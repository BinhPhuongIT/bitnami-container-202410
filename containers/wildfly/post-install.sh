#!/bin/bash
cd $BITNAMI_APP_DIR

# move the default conf directory
mv $BITNAMI_APP_DIR/standalone/configuration $BITNAMI_APP_DIR/standalone/conf.defaults
ln -sf $BITNAMI_APP_DIR/standalone/conf $BITNAMI_APP_DIR/standalone/configuration

# setup the logs
rm -rf $BITNAMI_APP_DIR/standalone/log
ln -sf $BITNAMI_APP_DIR/logs $BITNAMI_APP_DIR/standalone/log

# setup the default deployments
mv $BITNAMI_APP_DIR/standalone/deployments $BITNAMI_APP_DIR/standalone/deployments.defaults

# symlink mount points at root to install dir
ln -s $BITNAMI_APP_DIR/standalone/deployments /app
ln -s $BITNAMI_APP_DIR/standalone/conf $BITNAMI_APP_VOL_PREFIX/conf
ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs
