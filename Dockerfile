#
# hddtemp Dockerfile
#

# Pull base image.
FROM ubuntu:20.04
MAINTAINER Modem7

# Install hddtemp
RUN apt-get update && apt-get -y install build-essential hddtemp && rm -rf /var/lib/apt/lists/*

COPY hddtemp.db /etc/

EXPOSE 7634/udp 7634/tcp

# Define default command.
# example = -d --listen localhost --port 7634 /dev/s*
CMD hddtemp $HDDTEMP_ARGS
