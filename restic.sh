#!/bin/bash
source /etc/restic/restic.default
source /etc/restic/restic.properties

function initStorage() {
  if ! initialized; then
    echo "Initializing restic repo"
    restic init
    restic forget --keep-daily $backups_count
  else
    echo "Restic repo already initialized no need for initializing"
  fi
}

function initialized(){
    local returncode=1
    local counter=0
    until [[ "$returncode" -eq 0 ]] || [[ "$counter" -eq $retry_count ]]
    do
        restic snapshots > /dev/null
        returncode=$(echo $?)
        counter=$((counter+1))
    done
    echo $returncode
}

function pushSnapshot(){
  local base_dir=$1
  local snapshot_file_name=$2
  local BACKUP_FILE=$base_dir/$snapshot_file_name
  if initialized; then
    if [ ! -f "$BACKUP_FILE" ]; then
      echo "$BACKUP_FILE does not exist. Please check!!!!!!!!!!"
      exit 1
    fi
    echo "Pushing $base_dir/$snapshot_file_name to $RESTIC_REPOSITORY"

    pushd $base_dir
    restic backup $snapshot_file_name
    popd
  else
    echo "Restic repo $RESTIC_REPOSITORY is not initialized please check!!!!!"
    exit 1
  fi
}

function listSnapshots() {
  if initialized; then
    restic snapshots
  else
    echo "Restic repo $RESTIC_REPOSITORY is not initialized please check!!!!!"
    exit 1
  fi
}

function restoreSnapshot(){
    local snapshot_id=$1
    local restore_location=$2
    if initialized; then
      restic restore $snapshot_id -t /restore_location
    else
      echo "Restic repo $RESTIC_REPOSITORY is not initialized please check!!!!!"
      exit 1
    fi
}
