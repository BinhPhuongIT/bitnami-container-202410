FROM gcr.io/stacksmith-images/minideb:jessie-r1

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_IMAGE_VERSION=3.3.1-r0 \
    PATH=/opt/bitnami/ruby/bin:$PATH

# Additional modules required
RUN bitnami-pkg install ruby-2.1.10-1 --checksum aa7c266eda9468e204980b41427a0566176aff5103b6ef96b81f86a525bc8772
RUN bitnami-pkg install imagemagick-6.7.5-10-4 --checksum 02caf58e61a89db57ff3f62a412298fbaeff320cf32e196c9439959a197ed73d
RUN bitnami-pkg install mysql-libraries-10.1.13-2 --checksum 1b61acd1d1f0f204d1e2b0b59411d21c2d5724edd4cdf1d7925de0819213a6ad
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install redmine
RUN bitnami-pkg unpack redmine-3.3.1-0 --checksum 7220d457b70daeff3636d98096b6ec76d93d09a87fdfa9aa73ca1036a0a6fe2a

COPY rootfs /

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "redmine"]
