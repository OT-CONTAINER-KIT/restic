From alpine:3.11

LABEL VERSION=1.0 \
      ARCH=AMD64 \
      MAINTAINER="Vishal Raj" \
      DESCRIPTION="Restic Backup - docker image created by Opstree Solutions"

RUN apk add --no-cache bash restic

COPY restic.sh /scripts/
COPY restic.default /etc/restic/restic.default

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
