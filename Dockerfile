FROM ubuntu:14.04
MAINTAINER blue@aquarat.co.za

WORKDIR /build

# install tools and dependencies
RUN apt-get -y update 
RUN apt-get install -y --force-yes --no-install-recommends \
        curl git make g++ gcc g++ build-essential \
        libc6-dev wget file ca-certificates \
        binutils cmake3 libudev-dev
RUN apt-get clean

# install rustup
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# rustup directory
ENV PATH /root/.cargo/bin:$PATH

# show backtraces
ENV RUST_BACKTRACE 1

# show tools
RUN rustc -vV && cargo -V

RUN git clone https://github.com/paritytech/parity-ethereum.git /build

# build parity
#ADD . /build/parity
WORKDIR /build/parity
RUN mkdir -p .cargo
RUN cat .cargo/config && cargo build --release --verbose

RUN /usr/bin/strip /build/parity/target/release/parity
RUN file /build/parity/target/release/parity

EXPOSE 8080 8545 8180 30303 30303/udp
ENTRYPOINT ["/build/parity/target/release/parity"]

