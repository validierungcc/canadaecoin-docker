FROM ubuntu:18.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive
ENV BDB_PREFIX="/usr/local"
ENV LD_LIBRARY_PATH="/usr/local/lib"
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
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
        libevent-dev \
        ca-certificates \
        g++

RUN addgroup --gid 1000 ecoin && \
    adduser --disabled-password --gecos "" --home /ecoin --ingroup ecoin --uid 1000 ecoin

WORKDIR /ecoin
RUN wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz && \
    tar -xzvf db-4.8.30.NC.tar.gz && \
    cd db-4.8.30.NC/build_unix && \
    wget -O ../dist/config.guess https://git.savannah.gnu.org/cgit/config.git/plain/config.guess && \
    wget -O ../dist/config.sub https://git.savannah.gnu.org/cgit/config.git/plain/config.sub && \
    ../dist/configure --prefix=$BDB_PREFIX --enable-cxx && \
    make -j$(nproc) && \
    make install && \
    cd ../.. && \
    rm -rf db-4.8.30.NC db-4.8.30.NC.tar.gz

RUN mkdir /ecoin/.canadaecoin
VOLUME /ecoin/.canadaecoin

RUN git clone https://github.com/Canada-eCoin/eCoinCore.git /ecoin/canada-ecoin
WORKDIR /ecoin/canada-ecoin
RUN git checkout master

WORKDIR /ecoin/canada-ecoin
RUN ./autogen.sh
RUN ./configure --without-gui
RUN make

RUN mkdir -p /output && \
    cp /usr/local/lib/libdb_cxx-4.8.so /output/ && \
    cp /ecoin/canada-ecoin/src/canadaecoind /output/

FROM ubuntu:18.04
ENV LD_LIBRARY_PATH="/usr/local/lib"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libdb++-dev \
        libboost-all-dev \
        libssl-dev \
        libevent-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
COPY --from=builder /output/libdb_cxx-4.8.so /usr/local/lib/
COPY --from=builder /ecoin/canada-ecoin/src/canadaecoind /usr/local/bin/canadaecoind

RUN addgroup --gid 1000 ecoin && \
    adduser --disabled-password --gecos "" --home /ecoin --ingroup ecoin --uid 1000 ecoin

USER ecoin
WORKDIR /ecoin
RUN mkdir .canadaecoin
VOLUME /aurora/.canadaecoin
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 34331/tcp
EXPOSE 34330/tcp
