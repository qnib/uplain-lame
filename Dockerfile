ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=qnib
ARG FROM_IMG_NAME="uplain-init"
ARG FROM_BASE_TAG="bionic-20190612"
ARG FROM_IMG_TAG="2019-07-11"
ARG FROM_IMG_HASH=""
FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_BASE_TAG}_${FROM_IMG_TAG}${DOCKER_IMG_HASH} AS build

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
                build-essential \
                ca-certificates \
                curl \
                file
WORKDIR /usr/src/lame
RUN curl -sL https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz/download \
        |tar xfz - -C . --strip-components=1

## ARG Part
ARG NUM_THREADS=2
ARG CFLAGS_MARCH="core2"
ARG CFLAGS_OPT=2
ENV CFLAGS="-march=${CFLAGS_MARCH} -O${CFLAGS_OPT} -pipe"
ENV CXXFLAGS="${CFLAGS}"
RUN ./configure --prefix=/usr/local --enable-static --disable-shared \
 && make -j ${NUM_THREADS} \
 && make install
COPY ./bin/bench.sh /usr/local/bin/bench.sh
CMD ["/usr/local/bin/bench.sh"]
VOLUME /input
VOLUME /output