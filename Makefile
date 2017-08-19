
CMD=hugo

all: build deploy

.PHONY: watch setup build deploy

watch:
	$(CMD) server -D

setup:
	git@github.com:unused/blog.git && \
		git clone https://github.com/MunifTanjim/minimo themes/minimo

build:
	$(CMD) && \
		git reset . && \
		git add public/ && \
		git ci -m "Public build `date -u`"

deploy:
	git push origin master && \
		git subtree push --prefix public origin gh-pages

