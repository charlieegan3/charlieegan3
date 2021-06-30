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

# used inside docker
install_retry:
	if ! command -v retry &> /dev/null; then \
		sh -c "curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry && chmod +x /usr/local/bin/retry"; \
	fi

update_status:
	retry -t 10 -m 1 'curl -LO https://charlieegan3.github.io/json-charlieegan3/build/status.json'

update_readme:
	retry -t 10 -m 1 'racket updater/main.rkt -- status.json README.md'
