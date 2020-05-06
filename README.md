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
* restic.properties file
For the sake of security we have not shipped restic.properties in the image, hence you have to provide it via volume mounting as it contains critical information. Below is a sample of it:
```
export AWS_ACCESS_KEY_ID="XXXXXXXXXXXXXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXXXXXXXXXXXXXX"
export RESTIC_PASSWORD="XXXXXXXXXXXXXXXXXX"
export RESTIC_REPOSITORY="s3:https://s3.amazonaws.com/xxxxxxxxx"
```

* Logging
Now we have logging support enabled as well a log file will be created at ""/var/log/backup/restic.log"". Content of log fill will look something like.
```
[Wed May  6 03:26:44 UTC 2020] [DEBUG]  > resticEntrypoint SCRIPTENTRY
[Wed May  6 03:26:44 UTC 2020] [DEBUG]  > listSnapshots ENTRY
[Wed May  6 03:26:44 UTC 2020] [DEBUG]  > initialized ENTRY
[Wed May  6 03:26:44 UTC 2020] [DEBUG]  Validating repo is initialized in 1 attempt
[Wed May  6 03:27:02 UTC 2020] [DEBUG]  Validating repo is initialization done in 0 attempt
[Wed May  6 03:27:02 UTC 2020] [DEBUG]  < initialized EXIT
[Wed May  6 03:27:02 UTC 2020] [DEBUG]  Listing of snapshots
[Wed May  6 03:27:09 UTC 2020] [DEBUG]  < listSnapshots EXIT
```
* Initializing restic backend
This function will be called only once to initialize your backend storage
```
	docker run -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --rm opstree/restic:0.1 init
```

* Backup of a file:
For backup you need to provide 2 inputs
  * Folder containing file to be backed up
  * File that needs to be backed up

```
docker run -v ${PWD}/sample/log:/var/log/backup -v restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 backup <basefolder> <file>

i.e
docker run -v ${PWD}/sample/log:/var/log/backup -v restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 backup scripts restic.sh
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
