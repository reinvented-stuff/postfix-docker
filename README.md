# Postfix in Docker

Alpine Linux's Postfix in a Docker container: Postfix 3.11.7 on Alpine 3.24.

## What the image adds to Alpine's Postfix

- `/entrypoint.sh` checks that `/etc/postfix` holds `main.cf` and
  `master.cf`, then runs `postfix start-fg` as the container's process 1.
  Postfix's master then runs in init mode, `master -i`, and receives the
  SIGTERM of `docker stop` itself: it stops its child processes and exits at
  once, with exit code 0. `maillog_file = /dev/stdout` works only this way.
- A copy of Postfix's meta files, `postfix-files` and `dynamicmaps.cf` with
  their `.d` directories, in `/usr/share/postfix-docker/meta`. A configuration
  mounted over `/etc/postfix` hides the originals, and Postfix then stops at
  start with `/etc/postfix/postfix-files is not a file`; its `main.cf` sets
  `meta_directory = /usr/share/postfix-docker/meta`.

## Running it

The smallest `main.cf` of a configuration mounted over `/etc/postfix`:

```
compatibility_level = 3.11
meta_directory = /usr/share/postfix-docker/meta
maillog_file = /var/log/postfix.log
```

The image's own `master.cf` and `main.cf` are a start for the rest:

```bash
docker run --rm --entrypoint cat reinventedstuff/postfix-docker:3.11.7-amd64 /etc/postfix/master.cf
```

The queue, `/var/spool/postfix`, holds the mail Postfix has taken and not yet
passed on; mounted from the host, it outlives the container. So does
`/var/lib/postfix`, Postfix's data directory.

```bash
mkdir -pv /opt/postfix-relay/etc/postfix /opt/postfix-relay/var/spool/postfix \
  /opt/postfix-relay/var/lib/postfix /opt/postfix-relay/var/log
```

```bash
docker run \
  --name postfix-relay \
  --detach \
  --network host \
  -v /opt/postfix-relay/etc/postfix:/etc/postfix:ro \
  -v /opt/postfix-relay/var/spool/postfix:/var/spool/postfix \
  -v /opt/postfix-relay/var/lib/postfix:/var/lib/postfix \
  -v /opt/postfix-relay/var/log:/var/log \
  reinventedstuff/postfix-docker:3.11.7-amd64
```

`postfix logrotate` rotates `maillog_file`:
`docker exec postfix-relay postfix logrotate`.

## Building

```bash
docker build --build-arg APP_VERSION="$(cat .version)" -t "reinventedstuff/postfix-docker:$(cat .version)" .
```

A push to a branch named `build_*` builds the image in GitHub Actions and
pushes it to Docker Hub as `reinventedstuff/postfix-docker:<.version>-amd64`
(`.github/workflows/build.yml`).
