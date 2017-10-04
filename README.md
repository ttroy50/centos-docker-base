# CentOS 6.3 base image

Build a CentOS 6.3 base image for docker

Modified from https://github.com/blalor/docker-centos-base

## Building the rootfs

Building of the rootfs can only happen on a CentOS6.3 OS. 

After installing the OS, install febootstrap and xz

    yum install febootstrap xz

Then run the build_centos_63.sh to generate the centos63.tar.xz file.

A binary blob of the tar is checked in but you can regenerate if you need.

## Building the image

Once you have the tar file with basic rootfs you can build the image.

From this folder call docker build on the Dockerfile.

    docker build --rm -f c6.3base.dockerfile -t matrim/centos6.3:latest .

This image is available from https://hub.docker.com/r/matrim/centos6.3/



