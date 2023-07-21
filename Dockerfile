# syntax = docker/dockerfile-upstream:master-labs

FROM debian:bookworm AS builddeb

ENV DEBIAN_FRONTEND=noninteractive \
    DEBEMAIL=me@domain.com \
    EMAIL=me@domain.com
RUN --mount=type=cache,id=aptcache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=libcache,target=/var/lib/apt,sharing=locked \
    <<EOF
    set -xe
    rm -fv /etc/apt/apt.conf.d/docker-clean
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    apt-get update
    apt-get install -y \
            packaging-dev \
            debian-keyring \
            devscripts \
            equivs
EOF

RUN <<EOF
    set -x
    dget -x http://deb.debian.org/debian/pool/main/h/hddtemp/hddtemp_0.3-beta15-54.dsc
    cd hddtemp-0.3-beta15/
    mk-build-deps --install --remove
    dch --bpo "Rebuild for bullseye-backports."
    dpkg-buildpackage -us -uc
EOF


FROM debian:bookworm AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,id=aptcache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=libcache,target=/var/lib/apt,sharing=locked \
    <<EOF
    set -xe
    rm -fv /etc/apt/apt.conf.d/docker-clean
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    apt-get update
    apt-get install -y --no-install-recommends \
            automake                           \
            autopoint                          \
            build-essential                    \
            expect                             \
            gettext                            \
            pkg-config                         \
            wget
EOF

ADD --link --keep-git-dir=false https://github.com/modem7/hddtemp-bin.git /hddtemp

RUN <<EOF
    set -x
    cd hddtemp/
    wget 'https://savannah.gnu.org/cgi-bin/viewcvs/*checkout*/config/config/config.guess'
    wget 'https://savannah.gnu.org/cgi-bin/viewcvs/*checkout*/config/config/config.sub'
    expect <<-END
        spawn gettextize -f
        expect "Press Return to acknowledge the previous four paragraphs."
        send "\r"
        expect eof
END
    autoreconf -vif
    ./configure
    make
EOF

# Update Database from Gentoo

FROM debian:bookworm AS updatedb

ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,id=aptcache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=libcache,target=/var/lib/apt,sharing=locked \
    <<EOF
    set -xe
    rm -fv /etc/apt/apt.conf.d/docker-clean
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    apt-get update
    apt-get install -y wget 
EOF

COPY --link --chmod=755 files/updatedb.sh /updatedb.sh

RUN <<EOF
    set -x
    wget https://de.freedif.org/savannah/hddtemp/hddtemp.db
    ./updatedb.sh
EOF

FROM bitnami/minideb:bookworm as final
LABEL maintainer="modem7"

# Copy hddtemp deb
COPY --link --chmod=755 --from=builddeb /hddtemp_*_*.deb /tmp/

ENV DEBIAN_FRONTEND=noninteractive
RUN --mount=type=cache,id=aptcache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=libcache,target=/var/lib/apt,sharing=locked \
    <<EOF
    set -xe
    rm -fv /etc/apt/apt.conf.d/docker-clean
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
    apt-get update
    apt-get install -y --no-install-recommends netcat-openbsd
    apt-get install /tmp/hddtemp_*_*.deb
    rm -rf /tmp/hddtemp_*_*.deb
EOF

# Copy updated hddtemp binary
COPY --link --chmod=755 --from=build /hddtemp/src/hddtemp /usr/sbin/

# Copy hddtemp.db /usr/share/misc/
COPY --link --chmod=755 --from=updatedb /hddtemp.db /usr/share/misc/

EXPOSE 7634/udp 7634/tcp

HEALTHCHECK --interval=30s --timeout=20s --retries=3 --start-period=10s \
    CMD nc localhost 7634 -w 1 || exit 1

# Define default command.
# example = -q -d -F /dev/sd*
CMD hddtemp $HDDTEMP_ARGS
