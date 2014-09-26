btsync-docker-volume
=========

A Docker container for syncing mounted volumes or whatever.

### How to use

- Pull the Docker image

```sh
docker pull koodimonni/btsync-volume
```
- Run the container

```sh
docker run -d -name btsync -v /host/data:/data/ -p 55555:55555 koodimonni/btsync
```

Container deals you a random pass which you can see with
```$ docker logs```
- Custom ENVs
you can set these ENVs with docker to change btsync configs:
PASS - set password explicitly. Defaults: 'admin'
USER - set user explicitly.     Defaults to random hash
NAME - set btsync node-name.    Defaults: $HOSTNAME