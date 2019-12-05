# Pull the starting image
FROM alpine:3.10
MAINTAINER	chris102994<chris102994@yahoo.com>
# Package Versions
ARG S6_OVERLAY_VERSION=v1.21.4.0
ARG	S6_OVERLAY_ARCH=amd64
# Package Links
ARG BUILDER_SCRIPT=mkimage-alpine.bash
ARG BUILDER_SCRIPT_URL=https://raw.githubusercontent.com/gliderlabs/docker-alpine/master/builder/scripts/${BUILDER_SCRIPT}
ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.gz
#Setup Base Script
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
	echo "##### Downloading Container items via Curl #####" && \
		echo "##### Downloading GliderLabs Builder Script #####" && \
			curl -o /${BUILDER_SCRIPT} -L ${BUILDER_SCRIPT_URL} && \
			chmod +x \
					/${BUILDER_SCRIPT} && \
			./${BUILDER_SCRIPT} && \
			tar xvzf rootfs.tar.xz -C / && \
			sed -i -e 's/^root:!:/' /etc/shadow && \
		echo "##### Downloading S6 Overlay #####" && \
			curl -L -s ${S6_OVERLAY_URL} | tar xvzf - -C / && \
			chmod +x \
					/etc/s6/services/.s6-svscan/SIGHUP \
					/etc/s6/services/.s6-svscan/SIGINT \
					/etc/s6/services/.s6-svscan/SIGQUIT \
					/etc/s6/services/.s6-svscan/SIGTERM \
					/usr/bin/sv-getdeps && \
	echo "##### Creating user and folders #####" && \
		groupmod -g 1000 users && \
		useradd -u -911 -U -d /config -s /bin/false user && \
		usermod -G users user && \
		mkdir -p \
			/app \
			/config \
			defaults && \
	echo "##### Cleaning Up #####" && \
		apk del --purge build-dependencies && \
		rm -rf /tmp/
# This entry point is needed by s6 overlay - do not change
ENTRYPOINT	["/init"]
