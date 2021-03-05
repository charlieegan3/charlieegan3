all: update_status update_readme commit
	echo done

update_status:
	curl -LO https://charlieegan3.github.io/json-charlieegan3/build/status.json

update_readme:
	racket updater/main.rkt -- status.json README.md

test:
	raco test $$(find updater -type f | grep -v main.rkt)

watch_test:
	find . | entr bash -c 'clear && make test'

commit:
	./hack/commit.rb
