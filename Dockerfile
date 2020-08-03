# Dockerfile for a container capable of building the Courgette target of
# Chromium for Linux.

FROM ubuntu:bionic

WORKDIR /root

ENV TZ=America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive
ENV TAR_OPTIONS=" --no-same-owner"

# Install bootstrap dependencies
RUN apt-get update && apt-get install -y \
        curl \
        git \
        python \
        lsb-release \
	sudo

# Install the build dependencies
COPY install-build-deps.sh .
RUN ./install-build-deps.sh \
        --no-arm --no-chromeos-fonts --no-nacl \
        --no-prompt

# Copy in the build script and packaging materials
COPY build.sh .
COPY deb-package ./deb-package
RUN chmod +x build.sh

# Set the container command to run the build script
VOLUME /ws 
CMD ["/root/build.sh", "/ws", "no-update"]
