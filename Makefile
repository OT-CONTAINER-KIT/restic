build:
	docker build -t opstree/restic:0.1 .

run:
	docker run --entrypoint /bin/bash -v ${PWD}/sample/restic.properties:/etc/restic/restic.properties -it --rm opstree/restic:0.1
