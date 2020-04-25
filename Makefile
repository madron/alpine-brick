ALPINE_URL=http://dl-cdn.alpinelinux.org/alpine/v3.11/releases/aarch64/alpine-rpi-3.11.6-aarch64.tar.gz

.ONESHELL:


alpine-fetch:
	mkdir -p build/original
	cd build
	test -f alpine.tgz || wget -O alpine.tgz ${ALPINE_URL}
	cd build/original
	tar xfvz ../alpine.tgz