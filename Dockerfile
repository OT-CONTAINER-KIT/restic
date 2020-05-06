From alpine:3.11

LABEL VERSION=1.0 \
      ARCH=AMD64 \
      MAINTAINER="Vishal Raj" \
      DESCRIPTION="Restic Backup - docker image created by Opstree Solutions"

RUN apk add --no-cache bash restic
RUN addgroup -S backup && adduser --disabled-password --ingroup backup --uid 1001 backup

COPY scripts /scripts/
COPY restic.default /etc/backup/
#COPY resticEntrypoint.sh /
RUN mkdir /var/log/backup

RUN chown -R backup:backup /var/log/backup /etc/backup/ /scripts
USER backup

ENTRYPOINT ["/bin/bash", "/scripts/resticEntrypoint.sh"]
