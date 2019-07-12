ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=qnib
ARG FROM_IMG_NAME="uplain-init"
ARG FROM_BASE_TAG="bionic-20190612"
ARG FROM_IMG_TAG="2019-07-11"
ARG FROM_IMG_HASH=""

FROM qnib/white-noise:600s AS wav600s
FROM qnib/white-noise:1200s AS wav1200s
FROM qnib/white-noise:2400s AS wav2400s
FROM qnib/white-noise:3600s AS wav3600s

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

WORKDIR /data
COPY --from=wav600s /opt/white-600s.wav /data/white-600s.wav
COPY --from=wav1200s /opt/white-1200s.wav /data/white-1200s.wav
COPY --from=wav2400s /opt/white-2400s.wav /data/white-2400s.wav
COPY --from=wav3600s /opt/white-3600s.wav /data/white-3600s.wav
VOLUME /data
COPY bench.sh /usr/loca/bin/bench.sh