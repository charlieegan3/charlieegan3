test:
	raco test $$(find updater -type f | grep -v main.rkt)

watch_test:
	find . | entr bash -c 'clear && make test'

pkg_update:
	raco pkg update --update-deps --all
