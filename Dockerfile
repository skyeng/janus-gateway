FROM debian:stretch

LABEL maintainer="Nadezhda Ryabtsova <nadezhdaryabtsova@gmail.com>"
LABEL description="Provides an image with Janus Gateway"

RUN apt-get update

RUN apt-get install -y \
	git \
	build-essential \
	autoconf \
	automake \
	autotools-dev \
	dh-make \
	debhelper \
	devscripts \
	fakeroot \
	xutils \
	lintian \
	pbuilder

RUN apt-get install -y \
	libmicrohttpd-dev \
	libjansson-dev \
	libnice-dev \
	libssl-dev \
	libsrtp2-dev \
	libsofia-sip-ua-dev \
	libglib2.0-dev \
	libopus-dev \
	libogg-dev \
	pkg-config \
	gengetopt \
	libtool \
	automake \
	cmake \
	libwebsockets-dev \
	libavutil-dev \
	libavcodec-dev \
	libavformat-dev \
	liblua5.3-dev

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/janus /var/janus/janus/log /var/janus/janus/data && \
	cd /usr/src/janus && \
	git clone https://github.com/meetecho/janus-gateway.git 0.4.2-master-ca756d1 && \
    cd 0.4.2-master-ca756d1 && \
    git checkout ca756d17cb1b58cae93c71fce20ef49cbe37c00a && \
	sh autogen.sh && \
	./configure --prefix=/var/janus/janus --enable-post-processing --disable-rabbitmq --disable-data-channels && \
	make && make install && make configs && \
	rm -rf /usr/src/janus

EXPOSE 8088/tcp 8188/tcp
EXPOSE 8188/udp 20000-40000/udp

CMD /var/janus/janus/bin/janus --nat-1-1=${DOCKER_IP}
