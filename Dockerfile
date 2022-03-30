#
# hddtemp Dockerfile
#

# Pull base image.
FROM ubuntu:21.10
LABEL maintainer="modem7"

RUN apt-get update \
 && apt-get install software-properties-common && add-apt-repository universe && add-apt-repository multiverse \
 && DEBIAN_FRONTEND=noninteractive \
 && apt-get upgrade -y \ 
 && apt-get install --no-install-recommends -y \ 
            hddtemp \ 
            netcat \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

COPY hddtemp.db /usr/share/misc/

COPY files /temp
RUN rm -f /usr/sbin/hddtemp && \
          cp /temp/hddtemp /usr/sbin/ && \
          chmod +x /usr/sbin/hddtemp && \
          rm -fdr /temp

EXPOSE 7634/udp 7634/tcp

HEALTHCHECK --interval=30s --timeout=20s --retries=3 --start-period=10s \
    CMD nc localhost 7634 -w 1 || exit 1

# Define default command.
# example = -q -d -F /dev/sd*
CMD hddtemp $HDDTEMP_ARGS
