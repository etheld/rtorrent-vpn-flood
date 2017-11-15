
NAME = gwelican/openvpn

default: build

BUILD_ARGS = --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD`

build:
	docker build -t $(NAME) $(BUILD_ARGS) .

push:
	docker push $(NAME)

debug:
	docker run --rm -it $(NAME) /bin/bash

run:
	docker run --rm $(NAME)

release: build push