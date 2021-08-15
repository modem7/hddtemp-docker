#
# hddtemp Dockerfile
#

# Pull base image.
FROM ubuntu
LABEL maintainer="Alex Lane <modem7@gmail.com>"

# Install hddtemp
RUN apt-get update && apt-get -y --no-install-recommends install build-essential hddtemp && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY hddtemp.db /etc/

# Replace hddtemp with new build and cleanup
ADD files /temp
RUN rm -f /usr/sbin/hddtemp && \
    cp /temp/hddtemp /usr/sbin/ && \
    chmod +x /usr/sbin/hddtemp && \
    rm -fdr /temp

EXPOSE 7634

# Define default command.
# example = -d --listen localhost --port 7634 /dev/s*
CMD hddtemp $HDDTEMP_ARGS