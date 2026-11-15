FROM alpine:3.24@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf

ARG APP_VERSION=dev

LABEL org.opencontainers.image.title="postfix-docker"
LABEL org.opencontainers.image.description="Postfix in a Docker container."
LABEL org.opencontainers.image.authors="Pavel Kim <hello@pavelkim.com>"
LABEL org.opencontainers.image.url="https://github.com/reinvented-stuff/postfix-docker"
LABEL org.opencontainers.image.version="${APP_VERSION}"

RUN apk add --no-cache \
    mailx=8.1.2_git20220412-r1 \
    postfix=3.11.7-r0 \
    postfix-pcre=3.11.7-r0 \
    inetutils-telnet=2.8-r0

# Postfix reads postfix-files and dynamicmaps.cf from its meta_directory,
# /etc/postfix by default, so a configuration mounted over /etc/postfix hides
# them. This copy outlives the mount: a main.cf that mounts its own
# /etc/postfix sets meta_directory = /usr/share/postfix-docker/meta.
RUN mkdir -p /usr/share/postfix-docker/meta \
    && cp -a /etc/postfix/postfix-files /etc/postfix/postfix-files.d \
        /etc/postfix/dynamicmaps.cf /etc/postfix/dynamicmaps.cf.d \
        /usr/share/postfix-docker/meta/

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
