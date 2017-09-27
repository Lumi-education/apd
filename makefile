BRANCH = $(shell git rev-parse --abbrev-ref HEAD)

build:
	docker build -t lumi_apd:${BRANCH} .

.PHONY: dist build