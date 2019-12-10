#######################################################
# This is a 2 step build in order to keep the image	  #
# as small as possible and to make the overlay easier #
#######################################################

###########
# STAGE 1 #
###########
# Pull the starting image
FROM alpine:3.10 as rootfs-stage
# Package Links
ARG BUILDER_SCRIPT=mkimage-alpine.bash
ARG BUILDER_SCRIPT_URL=https://raw.githubusercontent.com/gliderlabs/docker-alpine/master/builder/scripts/${BUILDER_SCRIPT}
# ENV Vars for Builder Script
ENV REL=v3.10
ENV ARCH=x86_64
ENV MIRROR=http://dl-cdn.alpinelinux.org/alpine
ENV PACKAGES=alpine-baselayout,\
alpine-keys,\
apk-tools,\
busybox,\
libc-utils,\
xz
# Setup Base Script
RUN	echo "##### Downloading Virtual Build Dependencies #####" && \
		apk add --no-cache --virtual=build-dependencies \
			bash \
			curl \
			tar \
			tzdata \
			xz && \
	echo "##### Downloading Container items via Curl #####" && \
		echo "##### Downloading GliderLabs Builder Script #####" && \
			curl -o /${BUILDER_SCRIPT} -L ${BUILDER_SCRIPT_URL} && \
			chmod +x \
					/${BUILDER_SCRIPT} && \
			./${BUILDER_SCRIPT} && \
			mkdir /rootfs && \
			tar xf rootfs.tar.xz -C /rootfs && \
			sed -i -e 's/^root::/root:!:/' /rootfs/etc/shadow && \
	echo "##### Cleaning Up #####" && \
		apk del --purge build-dependencies

###########
# STAGE 2 #
###########
# This is the second stage build.		
FROM scratch
MAINTAINER chris102994<chris102994@yahoo.com>
COPY --from=rootfs-stage /rootfs/ /
ARG BUILD_DATE
ARG VERSION
# Package Versions
ARG S6_OVERLAY_VERSION=v1.21.4.0
ARG S6_OVERLAY_ARCH=amd64
# Package Links
ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.gz
# Setup Base Script
RUN	echo "##### Downloading Runtime Packages #####" && \
		apk add --no-cache \
			bash \
			ca-certificates \
			coreutils \
			shadow && \
	echo "##### Downloading Virtual Build Dependencies #####" && \
		apk add --no-cache --virtual=build-dependencies \
			curl \
			tar \
			tzdata \
			xz && \
	echo "##### Downloading S6 Overlay #####" && \
		curl -L -s ${S6_OVERLAY_URL} | tar xvzf - -C / && \
	echo "##### Creating user and folders #####" && \
		groupmod -g 1000 users && \
		useradd -u 900 -U -d /config -s /bin/false user && \
		usermod -G users user && \
		mkdir -p \
			/app \
			/config \
			/defaults && \
		groupmod -o -g 900 user && \
		usermod -o -u 900 user && \
	echo "##### Cleaning Up #####" && \
		apk del --purge build-dependencies
# Add Local Files
COPY rootfs/ /
# This entry point is needed by s6 overlay - do not change
ENTRYPOINT	["/init"]
