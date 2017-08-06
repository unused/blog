
CMD=hugo

all: build deploy

.PHONY: watch setup build deploy

watch:
	$(CMD) server -D

setup:
	git@github.com:unused/blog.git && \
		git clone https://github.com/MunifTanjim/minimo themes/minimo

build:
	$(CMD) && "Public build `date -u`"

deploy:
	git subtree push --prefix public origin gh-pages

