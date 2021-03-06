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
    apt-get install -y automake autoconf libtool

# add user 'docker' and allow copying to /usr/local/lib and so on -> required when copying shared library
RUN useradd -m docker &&\
	usermod -a -G root docker &&\
	chmod -R g+w /usr/local &&\
	chmod g+w /usr/share/pkgconfig

# install 'pymodbus' library using PyPi for Modbus server and client for HW test
RUN apt-get install -y python-pip && \
    yes | pip install pymodbus

# install 'libmodbus' library
RUN apt-get install -y libmodbus-dev

# clone 'better-enums' repo (header only library)
RUN cd /usr/include && \
    git clone https://github.com/aantron/better-enums

# install 'nlohman/json' library
RUN apt-get install -y nlohmann-json3-dev

# install 'spdlog' logging header only logging framework
RUN apt-get install -y libspdlog-dev

# download and extract boost library (version 1.72.0)
RUN apt-get install -y wget && \
    wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2 && \
    tar --bzip2 -xf boost_1_72_0.tar.bz2 -C /usr/include

# install 'doxygen' for code documentation
RUN apt-get install -y doxygen

# install Qt (and some additional installations) for UI development
RUN apt-get update &&\
	apt-get install -y qt5-default qtdeclarative5-dev &&\
	apt-get install -y qml-module-qtquick2 qml-module-qtquick-controls2 qml-module-qtquick-window2 &&\
	apt-get install -y mesa-utils libgl1-mesa-glx

# install pkg-config for including the application as shared library in the UI
RUN apt-get install -y pkg-config

# set correct time (used in logger)
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# clean up
RUN apt-get autoremove -y && \
    apt-get clean -y
