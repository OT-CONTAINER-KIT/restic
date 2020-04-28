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
  if initialized; then
    echo "Pushing $base_dir/$snapshot_file_name to $RESTIC_REPOSITORY"

    pushd $base_dir
    restic backup $snapshot_file_name
    popd
  else
    echo "Restic repo $RESTIC_REPOSITORY is not initialized please check!!!!!"
    exit 1
  fi
}

function pullSnapshot(){
    local snapshot_file_id=$1
    initStorage
    restic restore $restore_file_id -t /Common_SharedDir
}
