test:
	raco test .

watch_test:
	find . | entr bash -c 'clear && make test'
