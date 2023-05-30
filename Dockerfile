# Use a multi-stage build to optimize the final image size
FROM ubuntu:16.04 AS builder
ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        pkg-config \
        libboost-all-dev \
        libminiupnpc-dev \
        libssl-dev \
        libdb++-dev \
        ca-certificates \
        bsdmainutils && \
    rm -rf /var/lib/apt/lists/*

# Create user and group
RUN addgroup --gid 1000 ecoin && \
    adduser --disabled-password --gecos "" --home /ecoin --ingroup ecoin --uid 1000 ecoin

# Switch to the new user
USER ecoin

RUN mkdir /ecoin/.canadaecoin
VOLUME /ecoin/.canadaecoin

RUN git clone https://github.com/Canada-eCoin/Canada-eCoin-qt.git /ecoin/canada-ecoin
WORKDIR /ecoin/canada-ecoin
RUN git checkout master

WORKDIR /ecoin/canada-ecoin/src
RUN make -f makefile.unix

FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libboost-all-dev \
        libevent-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /ecoin/canada-ecoin/src/canadaecoind /usr/local/bin/canadaecoind
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN addgroup --gid 1000 ecoin && \
    adduser --disabled-password --gecos "" --home /ecoin --ingroup ecoin --uid 1000 ecoin


USER ecoin
RUN mkdir /ecoin/.canadaecoin
VOLUME /ecoin/.canadaecoin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 38348/tcp
EXPOSE 8048/tcp
