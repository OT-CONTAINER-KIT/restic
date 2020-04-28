From alpine:3.11

LABEL VERSION=1.0 \
      ARCH=AMD64 \
      MAINTAINER="Vishal Raj" \
      DESCRIPTION="Restic Backup - docker image created by Opstree Solutions"

RUN addgroup -S backup
RUN adduser --disabled-password --ingroup backup --uid 1001 backup

RUN apk add --no-cache bash restic

USER backup

COPY restic.sh /scripts/
COPY restic.default /etc/backup/

COPY resticEntrypoint.sh /

ENTRYPOINT ["/bin/bash", "/resticEntrypoint.sh"]
