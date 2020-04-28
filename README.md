# Restic

Docker wrapper over restic to manage backup/restore. Restic is a fast and secure backup program.
Currently below operations are supported:
* Backup
* Restore
* list

## Reposiotories supported
This docker image supports below repositories

Currently supported repository :
* Azure S3
* Minio server

Future supported repository :
* Local
* Azure BLOB

## Usage
* Backup of a file:
For backup you need provide 2 inputs
  * Folder containing file to be backed up
  * File that needs to be backed up

```
docker run -v restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 backup <basefolder> <file>

i.e
docker run -v restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 backup scripts restic.sh
```

* Restore of a file:
For restore you need provide 2 inputs
  * Snapshot ID of backup
  * Directory where backup to be restored

```
docker run -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 restore <snapshot_id> <restore_folder>

i.e
docker run -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 restore c6b69e10 /tmp
```
* Listing of backups
```
docker run -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 list
```  
## TODO
* Support environment variables
* Strengthen input validations

## Reference
* https://restic.readthedocs.io/en/latest/
* https://github.com/banzaicloud/docker-mysql-client
