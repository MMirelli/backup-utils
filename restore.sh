#!/bin/bash -x
BACKUP_DESTINATION=${1:-HOME}
BACKUP_NAME=${2:-$(uname -n)}
BACKUP_SOURCE_PREFIX="/tmp/Backups"
# BACKUP_SOURCE="${BACKUP_SOURCE_PREFIX}/${BACKUP_NAME}/${BACKUP_SOURCE/*\/}"
mkdir -p ${BACKUP_DESTINATION}
gpg --batch \
    --output "${BACKUP_SOURCE_PREFIX}/${BACKUP_NAME}.tgz" \
    --decrypt "${BACKUP_SOURCE_PREFIX}/${BACKUP_NAME}.tgz.gpg"
tar -xf \
    "${BACKUP_SOURCE_PREFIX}/${BACKUP_NAME}.tgz" \
    --directory "${BACKUP_DESTINATION}"
rm "${BACKUP_SOURCE_PREFIX}/${BACKUP_NAME}.tgz.gpg"
tree ${BACKUP_DESTINATION} | head -10
# xargs brew install < ~/my_brew.txt
