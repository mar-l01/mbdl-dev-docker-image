FROM debian:buster

LABEL maintainer="Markus Loipfinger <m.loipfinger@hotmail.de>"
LABEL author="Markus Loipfinger <m.loipfinger@hotmail.de>"
LABEL description="A Linux development image that is used to implement the modbus-data-logger application"

# install image requirements
RUN apt-get update && \
    # git integration
    apt install -y git && \
    # nano editor
    apt install -y nano && \
    # required for compiling, building and debugging
    apt-get install -y build-essential gdb cmake ninja-build && \
    # code formatting
    apt install -y clang-format && \
    apt-get install -y clang-tidy && \
    # modbus library requirements
    apt-get install -y automake autoconf libtool && \
    # add user 'docker'
    useradd -m docker

# clone 'libmodbus' repo and install libraries
RUN cd home/docker && \
    git clone https://github.com/stephane/libmodbus.git && \
    cd libmodbus && \
    ./autogen.sh && \
    ./configure && \
    make install

# clone 'better-enums' repo (header only library)
RUN cd home/docker && \
    git clone https://github.com/aantron/better-enums

# install 'nlohman/json' library
RUN apt-get install -y nlohmann-json3-dev

# clean up
RUN apt-get autoremove -y && \
    apt-get clean -y
