all: update_readme commit
	echo done

update_readme:
	./hack/update_readme.rb

commit:
	./hack/commit.rb

