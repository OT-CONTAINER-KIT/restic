#!/bin/bash
source /scripts/restic.sh
source /scripts/logging.sh
SCRIPTENTRY

case $1 in
  init)
    initStorage
    ;;
  backup)
    pushSnapshot $2 $3
    ;;
  list)
    listSnapshots
    ;;
  restore)
    restoreSnapshot $2 $3
    ;;
  *)
    echo -n "Please give valid input out of init|backup|list|restore"
    exit 1
    ;;
esac
