ARCH=aarch64
ALPINE_URL=http://dl-cdn.alpinelinux.org/alpine/v3.11/releases/aarch64/alpine-rpi-3.11.6-${ARCH}.tar.gz
PACKAGES_URL=http://dl-cdn.alpinelinux.org/alpine/v3.11/main/${ARCH}/
PACKAGES_IPTABLES=libmnl-1.0.4-r0.apk libnftnl-libs-1.1.5-r0.apk iptables-1.8.3-r2.apk iptables-openrc-1.8.3-r2.apk
PACKAGES_PYTHON=libbz2-1.0.8-r1.apk expat-2.2.9-r1.apk libffi-3.2.1-r6.apk gdbm-1.13-r1.apk \
				xz-libs-5.2.4-r0.apk ncurses-terminfo-base-6.1_p20200118-r3.apk \
				ncurses-libs-6.1_p20200118-r3.apk readline-8.0.1-r0.apk sqlite-libs-3.30.1-r1.apk \
 				python3-3.8.2-r0.apk
PACKAGES_PYTHON_LIBS=yaml-0.2.2-r1.apk py3-yaml-5.3.1-r0.apk
PACKAGES_RSYNC=libacl-2.2.53-r0.apk popt-1.16-r7.apk rsync-3.1.3-r2.apk rsync-openrc-3.1.3-r2.apk
PACKAGES=${PACKAGES_IPTABLES} ${PACKAGES_PYTHON} ${PACKAGES_PYTHON_LIBS} ${PACKAGES_RSYNC}

.ONESHELL:


all: output overlay usercfg


fetch-alpine:
	mkdir -p build/original
	cd build
	test -f alpine.tgz || wget -O alpine.tgz ${ALPINE_URL}
	cd original
	test -f config.txt || tar xfz ../alpine.tgz


fetch-packages:
	mkdir -p build/packages
	cd build/packages
	for PKG in ${PACKAGES}
	do
		test -f $$PKG || wget ${PACKAGES_URL}/$$PKG
	done


output: fetch-alpine
	mkdir -p build/output
	cd build
	cp -a original/* output/


overlay: fetch-alpine fetch-packages
	mkdir -p build/output
	tar --create --file=build/output/localhost.apkovl.tar -C overlay .
	tar --append --file=build/output/localhost.apkovl.tar -C build packages
	gzip -f build/output/localhost.apkovl.tar


usercfg:
	mkdir -p build/output
	cp usercfg.txt build/output/


clean:
	rm -rf build
