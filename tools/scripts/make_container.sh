#!/bin/bash

DATE=$(date)
VCS_REF=$(git rev-parse --short HEAD)



sudo docker build \
  --no-cache \
  --pull \
  --build-arg BASE_IMAGE="$BASE_IMAGE" \
  --build-arg BUILD_DATE="$DATE" \
  --build-arg VERSION="TODO" \
  --build-arg VCS_REF="$VCS_REF" \
  -f "$DOCKER_FILE" \
  -t "$DOCKER_REPO"/"$DOCKER_NAME":"$IMAGE_TAG" \
  .