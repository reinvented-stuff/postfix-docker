# Postfix in Docker

Postfix in a Docker container.

Postfix version: 3.7.3

```bash
mkdir -pv /opt/postfix-relay/etc/postfix
mkdir -pv /opt/postfix-relay/var/log
```

```bash
podman run \
  --name postfix-relay \
  --detach \
  --net host \
  --pid host \
  -ti \
  -p 25:25 \
  -v "/opt/postfix-relay/etc/postfix:/etc/postfix" \
  -v "/opt/postfix-relay/var/log:/var/log" \
  postfix:3.7.3
```


```bash
podman build --build-arg ARCH=amd64/ -t reinventedstuff/postfix-docker:$(cat .version) .
podman build --build-arg ARCH=amd64/ -t reinventedstuff/postfix-docker:$(cat .version) .
```