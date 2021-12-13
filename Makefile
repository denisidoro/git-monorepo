test:
	./test/integration

lint:
	dot code beautify ./git-monorepo
	find ./src -type f | xargs -I% dot code beautify %
	find ./test -type f | xargs -I% dot code beautify %