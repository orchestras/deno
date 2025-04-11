# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM alpine:3.21 AS alpine

WORKDIR /home/expert/workspace
LABEL devcontainer-feature-set="none"
USER root
ENV PATH=$PATH:/opt/volta/bin
RUN apk update --no-cache && apk add --no-cache \
    bash \
    deno \
    direnv \
    fish \
    go \
    ruby \
    xclip \
    xsel
ENTRYPOINT ["/usr/bin/fish", "-i"]