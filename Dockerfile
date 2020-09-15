#
# hddtemp Dockerfile
#

# Pull base image.
FROM ubuntu
MAINTAINER Modem7

# Install hddtemp
RUN apt-get update && apt-get -y install build-essential hddtemp && rm -rf /var/lib/apt/lists/*


COPY hddtemp.db /etc/

# Define default command.
# example = -d --listen localhost --port 7634 /dev/s*
CMD hddtemp $HDDTEMP_ARGS
