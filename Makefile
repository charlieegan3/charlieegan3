all: install_retry update_status update_readme commit
	echo done

install_retry:
	if ! command -v retry &> /dev/null; then \
		sudo sh -c "curl https://raw.githubusercontent.com/kadwanev/retry/master/retry -o /usr/local/bin/retry && chmod +x /usr/local/bin/retry"; \
	fi

update_status:
	retry -t 10 -m 1 'curl -LO https://charlieegan3.github.io/json-charlieegan3/build/status.json'

update_readme:
	retry -t 10 -m 1 'racket updater/main.rkt -- status.json README.md'

test:
	raco test $$(find updater -type f | grep -v main.rkt)

watch_test:
	find . | entr bash -c 'clear && make test'

commit:
	./hack/commit.rb
