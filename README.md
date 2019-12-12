# A minimal docker base image that supports long-term deployment.

This is a docker base image that can be used as a baseline for future containers that will be utilized for long-term deployments.

 [![Build Status](https://travis-ci.com/chris102994/docker-base-image.svg?branch=master)](https://travis-ci.com/chris102994/docker-base-image)
  
## **Custom Scripts**
* [/usr/local/bin](https://github.com/chris102994/docker-base-image/tree/master/rootfs/usr/local/bin)
  * [check_and_terminate_process](https://github.com/chris102994/docker-base-image/blob/master/rootfs/usr/local/bin/check_and_terminate_process) - Since Alpine Linux provides a minimal install and the s6-overlay doesn't provide a traditional method of verifying services this is a basic but powerful script I have written that is an all-in-one solution to find, terminate and possibly force kill processes. This utilizes the minimized pgrep provided by busybox in Alpine Linux.
    * Usage: `check_and_terminate_process "name_of_service"`

## **Outside Packages**
* [Glider Labs rootfs Builder](https://github.com/gliderlabs/docker-alpine/tree/master/builder)
* [S6 Overlay](https://github.com/just-containers/s6-overlay) 
    * [Further Documentation](https://github.com/just-containers/s6-overlay/blob/master/README.md)
