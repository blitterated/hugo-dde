Want to build a Hugo static site while keeping all the dev dependencies separate from your machine? This is the repo for you.

### Features

* `hugo server` runs as an [s6](https://skarnet.org/software/s6/overview.html) service via [s6-overlay](https://github.com/just-containers/s6-overlay).
* All Hugo and npm related dependencies are confined to the docker image.
* An open shell prompt for running adhoc `hugo` or `npm` commands in the container is available.
* Source code for the website is bind mounted from the host allowing use of host's IDEs.

### Requirements

This image builds on the [Docker Dev Environment](https://github.com/blitterated/docker_dev_env) image. Make sure that one is already built and available on your host.

### Build an image

```sh
docker build -t s6hugo.
```

### Run the image

__NOTE:__ This depends on `blog/` being passed into `hugo server` with the `-s` switch in the s6 [`run`](./run#L2) script.


```sh
docker run -it --rm \
           -v "$(pwd)":/blog \
           -w /blog  --name hugo-docker-s6 \
           -p 1313:1313 \
           s6hugo
```

### Manually stopping and starting the Hugo server in the container

You shouldn't really need to do this, but sometimes the Hugo server misses a file addition. This should help.

__Stopping__

```sh
s6-rc -d change hugo
```

__Starting__

```sh
s6-rc -u change hugo
```
