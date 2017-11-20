
NAME = gwelican/openvpn


VPN_USER=test
VPN_PASS=test

default: build

BUILD_ARGS = --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` --build-arg VCS_REF=`git rev-parse --short HEAD`

build:
	rm -rf config/
	rm -rf data/
	docker build -t $(NAME) $(BUILD_ARGS) .

push:
	docker push $(NAME)

debug:
	docker run --rm -it $(NAME) /bin/bash

run:
	docker run -p 3000:3000 -e PUID=501 -e PGID=20 -v $(PWD)/data:/data -v $(PWD)/config:/config --dns=8.8.8.8 --dns=8.8.4.4 -e OPENVPN_CONFIG=/config/default.vpn -e OPENVPN_USERNAME=$(VPN_USER) -e OPENVPN_PASSWORD=$(VPN_PASS) -v $(PWD)/ca58.nordvpn.com.tcp443.ovpn:/config/default.vpn --cap-add=NET_ADMIN --device=/dev/net/tun --rm $(NAME)

release: build push