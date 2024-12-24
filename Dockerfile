# Last LTS that contains an npm version old enough to build tellstick-server/api
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary dependencies
RUN apt-get update && \
    apt-get install -y build-essential curl git gpg npm python2.7 python2.7-dev virtualenv

RUN git clone --branch v1.3.2 https://github.com/telldus/tellstick-server.git /usr/src/tellstick-server

# Set Python 2.7 as the default Python version
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

WORKDIR /usr/src/tellstick-server

# Last version to support python 2.7
RUN echo "rsa==4.0" >> api/requirements.txt

# Need to use pip version 19.2.3 because tellstick-server/sdk is using pip
# internals to download dependencies. Tsk tsk...
#
# ./tellstick.sh will try to create an updated (incompatible) virtual
# environment by default. So create a working one manually instead.
RUN virtualenv --no-pip --python=python2.7 build/env
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    ./build/env/bin/python get-pip.py pip==19.2.3

# It might be possible to get away with only "./tellstick.sh install sdk" which
# contains the telldus_plugin command for setup.py. This builds everything.
RUN ./tellstick.sh setup
