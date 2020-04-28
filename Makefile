build:
	docker build -t opstree/restic:0.1 .

run-entrypoint:
	docker run --entrypoint /bin/bash -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1

initialize:
	docker run -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 init

backup:
	docker run -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 backup scripts restic.sh

backup-failure:
	docker run -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 backup script restic.sh

list:
	docker run -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 list

restore-snapshot:
	docker run -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1 restore c6b69e10 /tmp

end-to-end-test:
	make initialize
	make backup
	make list
	make restore-snapshot
	make backup-failure || true
