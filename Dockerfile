From alpine:3.11

LABEL VERSION=1.0 \
      ARCH=AMD64 \
      MAINTAINER="Vishal Raj" \
      DESCRIPTION="Restic Backup - docker image created by Opstree Solutions"

RUN apk add --no-cache bash restic
RUN addgroup -S backup && adduser --disabled-password --ingroup backup --uid 1001 backup

COPY restic.sh /scripts/
COPY restic.default /etc/backup/

RUN chown -R backup:backup /etc/backup/
USER backup

COPY resticEntrypoint.sh /

ENTRYPOINT ["/bin/bash", "/resticEntrypoint.sh"]
