# A minimal docker base image that supports long-term deployment.

This is a docker base image that can be used as a baseline for future containers that will be utilized for long-term deployments.

 [![Build Status](https://travis-ci.com/chris102994/docker-base-image.svg?branch=master)](https://travis-ci.com/chris102994/docker-base-image)
[![Microbadger Size & Layers](https://images.microbadger.com/badges/image/christopher102994/docker-base-image.svg)](https://microbadger.com/images/christopher102994/docker-base-image "Get your own image badge on microbadger.com")
 [![Image Pulls](https://img.shields.io/docker/pulls/christopher102994/docker-base-image)](https://hub.docker.com/repository/docker/christopher102994/docker-base-image)
 [![Alpine](https://images.microbadger.com/badges/version/christopher102994/docker-base-image:alpine-3.10-latest.svg)](https://microbadger.com/images/christopher102994/docker-base-image:alpine-3.10-latest "Get your own version badge on microbadger.com")
 [![Debian](https://images.microbadger.com/badges/version/christopher102994/docker-base-image:debian-10-latest.svg)](https://microbadger.com/images/christopher102994/docker-base-image:debian-10-latest "Get your own version badge on microbadger.com")
 [![Ubuntu](https://images.microbadger.com/badges/version/christopher102994/docker-base-image:ubuntu-18-latest.svg)](https://microbadger.com/images/christopher102994/docker-base-image:ubuntu-18-latest "Get your own version badge on microbadger.com")

## **Custom Scripts**
* [/usr/local/bin](https://github.com/chris102994/docker-base-image/tree/master/rootfs/usr/local/bin)
  * [inst-pkg](https://github.com/chris102994/docker-base-image/blob/master/rootfs/usr/local/bin/inst-pkg) - This is a install script which allows me to use common syntax across debian and alpine images. It's especially handy since apt-get doesn't include the nice `--virtual` tag that apk does to easily install build dependencies not needed for further use.
    * Usage: `inst-pkg [--virtual NAME ] PKG [PKG...]`
  * [rm-pkg](https://github.com/chris102994/docker-base-image/blob/master/rootfs/usr/local/bin/rm-pkg) - This is a remove script which allows me to use common syntax across debian and alpine images. It's especially handy since apt-get doesn't include the nice `--virtual` tag that apk does to easily remove build dependencies not needed for further use.
    * Usage: `rm-pkg PKG [PKG...]`
  * [check_and_terminate_process](https://github.com/chris102994/docker-base-image/blob/master/rootfs/usr/local/bin/check_and_terminate_process) - Since Alpine Linux provides a minimal install and the s6-overlay doesn't provide a traditional method of verifying services this is a basic but powerful script I have written that is an all-in-one solution to find, terminate and possibly force kill processes. This utilizes the minimized pgrep provided by busybox in Alpine Linux.
    * Usage: `check_and_terminate_process "name_of_service"`

## **Outside Packages**
* [Glider Labs rootfs Builder](https://github.com/gliderlabs/docker-alpine/tree/master/builder)
* [S6 Overlay](https://github.com/just-containers/s6-overlay) 
    * [Further Documentation](https://github.com/just-containers/s6-overlay/blob/master/README.md)
