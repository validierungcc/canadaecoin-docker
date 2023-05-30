FROM ubuntu:20.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        autoconf \
        automake \
        libtool \
        bsdmainutils \
        pkg-config \
        libssl-dev \
        libdb5.3++-dev \
        libboost-all-dev \
        ca-certificates \
        g++

RUN addgroup --gid 1000 ecoin && \
    adduser --disabled-password --gecos "" --home /ecoin --ingroup ecoin --uid 1000 ecoin


USER ecoin
RUN mkdir /ecoin/.canadaecoin
VOLUME /ecoin/.canadaecoin

RUN git clone https://github.com/Canada-eCoin/eCoinCore.git /ecoin/canada-ecoin
WORKDIR /ecoin/canada-ecoin
RUN git checkout master

WORKDIR /ecoin/canada-ecoin
RUN ./autogen.sh
RUN ./configure --without-gui --with-incompatible-bdb
RUN make

FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libdb++-dev \
        libboost-all-dev \
        libssl-dev \
        libevent-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /ecoin/canada-ecoin/src/canadaecoind /usr/local/bin/canadaecoind
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN addgroup --gid 1000 ecoin && \
    adduser --disabled-password --gecos "" --home /ecoin --ingroup ecoin --uid 1000 ecoin

USER ecoin
WORKDIR /ecoin
RUN mkdir .canadaecoin
VOLUME /aurora/.canadaecoin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 12340/tcp
EXPOSE 12341/tcp
COPY ./entrypoint.sh /
