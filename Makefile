ifndef RESTIC_IMAGE_VERSION
override RESTIC_IMAGE_VERSION = 0.2
endif


build:
	docker build --no-cache  -t opstree/restic:$(RESTIC_IMAGE_VERSION) .

run-entrypoint:
	docker run --entrypoint /bin/bash -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --rm opstree/restic:$(RESTIC_IMAGE_VERSION)

initialize:
	docker run -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --rm opstree/restic:$(RESTIC_IMAGE_VERSION) init

backup:
	docker run -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --rm opstree/restic:$(RESTIC_IMAGE_VERSION) backup scripts restic.sh

backup-failure:
	docker run -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --rm opstree/restic:$(RESTIC_IMAGE_VERSION) backup scripts restic_failure.sh

list:
	docker run -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --rm opstree/restic:$(RESTIC_IMAGE_VERSION) list

restore-snapshot:
	docker run -v ${PWD}/sample/log:/var/log/backup -v ${PWD}/sample/restic.properties:/etc/backup/restic.properties -it --rm opstree/restic:$(RESTIC_IMAGE_VERSION) restore latest /tmp

end-to-end-test:
	> sample/log/restic.log
	make initialize
	make backup
	make list
	make restore-snapshot
	make backup-failure || true
