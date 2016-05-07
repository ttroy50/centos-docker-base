#!/bin/bash

set -e

## requires running as root because filesystem package won't install otherwise,
## giving a cryptic error about /proc, cpio, and utime.  As a result, /tmp
## doesn't exist.
[ $( id -u ) -eq 0 ] || { echo "must be root"; exit 1; }

OS=`lsb_release -is`
VER=`lsb_release -rs`

if [ "$OS" != "CentOS" ]; then
    echo "Needs to be run on CentOS"
    exit 1
fi

if [ "$VER" != "6.3" ]; then
    echo "Nees to be run on CentOS 6.3"
    exit 1
fi

tmpdir=$( mktemp -d )
trap "echo removing ${tmpdir}; rm -rf ${tmpdir}" EXIT

febootstrap \
    -u http://vault.centos.org/6.3/os/x86_64/ \
    -i centos-release \
    -i yum \
    -i iputils \
    -i tar \
    -i which \
    centos63 \
    ${tmpdir} \
    http://vault.centos.org/6.3/os/x86_64/

febootstrap-run ${tmpdir} -- sh -c 'echo "NETWORKING=yes" > /etc/sysconfig/network'

## set timezone of container to UTC
febootstrap-run ${tmpdir} -- ln -f /usr/share/zoneinfo/Etc/UTC /etc/localtime

febootstrap-run ${tmpdir} -- yum clean all

## xz gives the smallest size by far, compared to bzip2 and gzip, by like 50%!
febootstrap-run ${tmpdir} -- tar -cf - . | xz > centos63.tar.xz
