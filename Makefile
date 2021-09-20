all: docker_update commit
	echo done

test:
	raco test $$(find updater -type f | grep -v main.rkt)

watch_test:
	find . | entr bash -c 'clear && make test'

commit:
	./hack/commit.rb

docker_update:
	tag=readme && \
	docker build -t $$tag . && \
	container=$$(docker create $$tag exit) && \
	docker cp $$container:/README.md README.md

update_status:
	curl -LO https://charlieegan3.github.io/json-charlieegan3/build/status.json

update_readme:
	racket updater/main.rkt -- status.json README.md
