# Postfix in Docker

Postfix version: 3.7.3

```bash
mkdir -pv /opt/postfix-relay/etc/postfix
mkdir -pv /opt/postfix-relay/var/log
```

```bash
podman run \
  --name postfix-relay \
  --detach \
  -ti \
  -p 25:25 \
  -v "/opt/postfix-relay/etc/postfix:/etc/postfix" \
  -v "/opt/postfix-relay/var/log:/var/log" \
  postfix:3.7.3
```
