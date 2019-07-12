SHELL:=/bin/bash
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all: build

build:
	docker build -t tfs-fastapi:latest -t radaisystems/tfs-fastapi:latest --build-arg TFS_VERSION=latest --progress plain -f ./dockerfile .

testenv:
	docker-compose up --build

docker_deps:
	docker pull tensorflow/serving:latest

clean_docker:
	docker-compose down

clean:
	rm -rf $(ROOT_DIR)/env; \
	rm -rf $(ROOT_DIR)/*.pyc;
	rm -rf $(ROOT_DIR)/*.egg-info;
