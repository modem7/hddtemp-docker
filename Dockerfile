#
# hddtemp Dockerfile
#

# Pull base image.
FROM ubuntu:20.04
LABEL maintainer="Alex Lane"

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

HEALTHCHECK --interval=30s --timeout=20s --retries=3 --start-period=10s \
    CMD nc localhost 7634 -w 1 || exit 1

# Define default command.
# example = -q -d -F /dev/sd*
CMD hddtemp $HDDTEMP_ARGS