FROM alpine:3.17

ARG APP_VERSION=dev
ARG POSTFIX_VERSION=dev
ARG POSTFIX_LISTEN_PORT=2500

LABEL org.opencontainers.image.title="postfix-docker"
LABEL org.opencontainers.image.description="Postfix in a Docker container."
LABEL org.opencontainers.image.authors="Pavel Kim <hello@pavelkim.com>"
LABEL org.opencontainers.image.url="https://github.com/reinvented-stuff/postfix-docker"
LABEL org.opencontainers.image.version="${APP_VERSION}"

RUN apk update && \
  apk add --no-cache mailx=8.1.1-r3 postfix=3.7.3-r1 inetutils-telnet=2.4-r0

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
