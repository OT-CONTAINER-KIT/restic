#!/bin/bash
source /etc/backup/restic.default
source /etc/backup/restic.properties

function initStorage() {
  ENTRY
  if ! initialized; then
    DEBUG "Initializing restic repo"
    restic init
    restic forget --keep-daily $backups_count
  else
    DEBUG "Restic repo already initialized no action needed"
  fi
  EXIT
}

function initialized(){
  ENTRY
  local returncode=1
  local counter=0
  until [[ "$returncode" -eq 0 ]] || [[ "$counter" -eq $retry_count ]]
  do
    DEBUG "Validating repo is initialized in $returncode attempt"
    restic snapshots > /dev/null
    returncode=$(echo $?)
    counter=$((counter+1))
  done
  DEBUG "Validating repo is initialization done in $returncode attempt"
  echo $returncode
  EXIT
}

function pushSnapshot(){
  ENTRY
  local base_dir=$1
  local snapshot_file_name=$2
  local BACKUP_FILE=$base_dir/$snapshot_file_name
  if initialized; then
    if [ ! -f "$BACKUP_FILE" ]; then
      ERROR "$BACKUP_FILE does not exist. Please check!!!!!!!!!!"
      exit 1
    fi
    DEBUG "Pushing $BACKUP_FILE to $RESTIC_REPOSITORY"
    pushd $base_dir
    restic backup $snapshot_file_name
    popd
  else
    ERROR "Restic repo $RESTIC_REPOSITORY is not initialized please check!!!!!"
    exit 1
  fi
  EXIT
}

function listSnapshots() {
  ENTRY
  if initialized; then
    DEBUG "Listing of snapshots"
    restic snapshots
  else
    ERROR "Restic repo $RESTIC_REPOSITORY is not initialized please check!!!!!"
    exit 1
  fi
  EXIT
}

function restoreSnapshot(){
  ENTRY
  local snapshot_id=$1
  local restore_location=$2
  if initialized; then
    DEBUG "Restoring $snapshot_id at $restore_location"
    restic restore $snapshot_id -t $restore_location
  else
    ERROR "Restic repo $RESTIC_REPOSITORY is not initialized please check!!!!!"
    exit 1
  fi
  EXIT
}
