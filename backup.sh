#!/bin/bash -x
# BACKUP_DESTINATION="$HOME/Backups/$(uname -n)/$USER"
# for now assume no pre-existing backup exists
BACKUP_SOURCE=${1:-HOME}
BACKUP_NAME=${2:-$(uname -n)}
# BACKUP_DESTINATION_PREFIX="/tmp/Backups"
TMP_BACKUP_DESTINATION_PREFIX="/tmp/Backups"
TMP_BACKUP_DESTINATION="${TMP_BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}/${BACKUP_SOURCE/*\/}"

BACKUP_DESTINATION_PREFIX="$HOME/Backups"
BACKUP_DESTINATION="${BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}/${BACKUP_SOURCE/*\/}"
mkdir -p "${BACKUP_DESTINATION}"
# brew leaves > $BACKUP_SOURCE/my_brew.txt

rdiff-backup backup \
             --exclude $BACKUP_SOURCE/.local \
             --exclude $BACKUP_SOURCE/Google\ Drive \
             --exclude $BACKUP_SOURCE/Library \
             --exclude $BACKUP_SOURCE/Downloads \
             --exclude $BACKUP_SOURCE/go \
             --exclude $BACKUP_SOURCE/Backups \
             --exclude $BACKUP_SOURCE/Desktop \
             --exclude $BACKUP_SOURCE/.Trash \
             --exclude $BACKUP_SOURCE/.viminfo \
             "$BACKUP_SOURCE" "${TMP_BACKUP_DESTINATION}"
verbose_tar_flag=''
path_components_to_strip=$(( $(echo "${BACKUP_DESTINATION}" | tr '/' '\n' | wc -l) - 1 ))
tar --strip-components ${path_components_to_strip} \
    -cf "${TMP_BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}.tgz" \
    "${TMP_BACKUP_DESTINATION}"

rm -rf "${TMP_BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}"

gpg --batch \
    --output "${BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}.tgz.gpg" \
    --symmetric \
    "${TMP_BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}.tgz"

rm "${TMP_BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}.tgz"

cat "${BACKUP_DESTINATION_PREFIX}/${BACKUP_NAME}.tgz.gpg" | head -10
tree "${BACKUP_DESTINATION_PREFIX}"

