#
# Sets up a building environment for a modified version of Okular.
# By Matthias Baumgartner, 2018
# 
# Build Okular, might take a while
# $ docker build .
#
# List docker images, with IDs.
# Identify the right one (probably the top one)
# $ docker images
#
# If for any reason you need to inspect the result,
# enter the docker image:
# $ docker run -i -t [ID]
# [You're dropped into a bash inside the image]
# # cd /root/okular/build
#
# Copy the libraries to the host
# $ docker run --entrypoint cat [ID] /root/okular/build/okularpart.so > okularpart.so
# $ docker run --entrypoint cat [ID] /root/okular/build/okularpart.so > okularpart.so
# 
# Move the files to the right location
# $ sudo mv okularpart.so /usr/lib/x86_64-linux-gnu/qt5/plugins/
# $ sudo mv libOkular5Core.so.8.0.0 /usr/lib/x86_64-linux-gnu
#
# Fix file permissions
# $ sudo chown root: /usr/lib/x86_64-linux-gnu/qt5/plugins/okularpart.so
# $ sudo chmod 644 /usr/lib/x86_64-linux-gnu/qt5/plugins/okularpart.so
# $ sudo chown root: /usr/lib/x86_64-linux-gnu/libOkular5Core.so.8.0.0
# $ sudo chmod 644 /usr/lib/x86_64-linux-gnu/libOkular5Core.so.8.0.0
#
# Remove docker remains
# WARNING: The following commands remove ALL containers and images.
# If you have other containers and/or images, remove them selectively.
# $ docker container prune
# $ docker image prune
#

## Base
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

## Install software

# Install build toolchain
RUN apt-get update && \
    apt-get install -y git cmake g++ extra-cmake-modules gettext

# Install essential build dependencies
RUN apt-get install -y  libkf5config-dev \
                        libqt5svg5-dev \
                        qtdeclarative5-dev \
                        libkf5archive-dev \
                        libkf5bookmarks-dev \
                        libkf5kio-dev \
                        libkf5threadweaver-dev \
                        libkf5kjs-dev \
                        libkf5doctools-dev \
                        libkf5wallet-dev \
                        libkf5parts-dev \
                        libkf5coreaddons-dev \
                        libkf5crash-dev \
                        libkf5iconthemes-dev \
                        libkf5activities-dev \
                        kirigami2-dev \
                        libphonon4qt5-dev \
                        libkf5pty-dev \
                        zlib1g-dev \
                        libpoppler-qt5-dev

# Install the OPTIONAL packages
RUN apt-get install -y  libqt5texttospeech5-dev \
                        libkf5purpose-dev \
                        libkf5kexiv2-dev \
                        libtiff-dev \
                        libfreetype6-dev \
                        libepub-dev \
                        libqmobipocket-dev \
                        libmarkdown2-dev

# Install the RECOMMENDED packages
RUN apt-get install -y  libspectre-dev \
                        libchm-dev \
                        libkf5khtml-dev \
                        libzip-dev \
                        libdjvulibre-dev \
                        libjpeg-dev \
                        libqca-qt5-2-dev 

## Get sources
RUN git clone -b mb/annotations-17.12.3 https://github.com/untersuecher/okular /root/okular

## CMake
RUN mkdir /root/okular/build && \
    cd /root/okular/build && \
    cmake -DCMAKE_BUILD_TYPE=Release ..

## build!
RUN cd /root/okular/build && \
    make

ENTRYPOINT ["/bin/bash"]
