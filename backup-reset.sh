#!/bin/bash -x
BACKUP_SOURCE=${1:-HOME}
BACKUP_NAME=${2:-$(uname -n)}
BACKUP_DESTINATION_PREFIX="/tmp/Backups"
BACKUP_DESTINATION="${BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}/${BACKUP_SOURCE/*\/}"

rm -rf \
   "${BACKUP_DESTINATION}" \
   "${BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}.tgz" \
   "${BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}.tgz.gpg"

tree "${BACKUP_DESTINATION}"
   