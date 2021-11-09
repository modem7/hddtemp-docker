#
# hddtemp Dockerfile
#

# Pull base image.
FROM ubuntu:20.04
MAINTAINER Modem7

COPY scripts/dependencies.json /tmp/dependencies.json

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
 && apt-get install -y --no-install-recommends jq \
 && jq -r 'to_entries | .[] | .key + "=" + .value' /tmp/dependencies.json | xargs apt-get install -y --no-install-recommends \
 && rm /tmp/dependencies.json \
 && apt-get purge -y jq \
 && apt-get clean \
 && apt autoremove -y \
 && rm -rf /var/lib/apt/lists/*

COPY hddtemp.db /etc/

EXPOSE 7634/udp 7634/tcp

# Define default command.
# example = -d --listen localhost --port 7634 /dev/s*
CMD hddtemp $HDDTEMP_ARGS
