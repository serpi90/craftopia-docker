FROM ubuntu:20.04

SHELL ["/bin/bash", "-e", "-u", "-o", "pipefail", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive; \
    dpkg --add-architecture i386 ; \
    apt-get update --assume-yes ; \
    echo steam steam/question select "I AGREE" | debconf-set-selections; \
    echo steam steam/license note '' | debconf-set-selections; \
    apt-get install --assume-yes --no-install-recommends \
      ca-certificates \
      gosu \
      lib32gcc1 \
      locales \
      steamcmd \
      ; \
    rm -rf /var/lib/apt/lists/*; \
    ln -s /usr/games/steamcmd /usr/bin/steamcmd; \
    groupadd steam; \
    useradd -m -s /bin/false -g steam steam; \
    locale-gen en_US.UTF-8


COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY server-entrypoint.sh /server-entrypoint.sh
RUN chmod u+x docker-entrypoint.sh server-entrypoint.sh

# Unicode support
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'
# Settings
ENV PORT=7777
ENV INSTALL_PATH="/craftopia-server"

# I/O
# TCP: 6587,27015-27030,27036-27037
# UDP: 4380,27000-27031,27036

# Cache installation
VOLUME $INSTALL_PATH
# Cache steamcmd
VOLUME /home/steam/.steam/

# Expose and run
WORKDIR $INSTALL_PATH
CMD /docker-entrypoint.sh
