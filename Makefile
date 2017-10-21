
CMD=hugo

all: build deploy

.PHONY: watch build deploy

watch:
	$(CMD) server -D

build:
	$(CMD) && \
		git reset . && \
		git add public/ && \
		git ci -m "Public build `date -u`"

deploy:
	git push origin master && \
		git subtree push --prefix public origin gh-pages

