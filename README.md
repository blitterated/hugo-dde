Want to build a Hugo static site while keeping all the dev dependencies separate from your host machine? This is the repo for you.

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
docker run -it --rm --name hugo-docker-s6 \
           -v "$(pwd)":/blog \
           -w /blog \
           -p 1313:1313 \
           s6hugo
```

### Create a new hugo site

It's a little hacky, but you need to override the Entrypoint and the Command on the command line. It will exit immediately after creating the new site.

```sh
docker run --rm --name hugo-new-site \
           -v "$(pwd)":/blog \
           -w /blog \
           --entrypoint "" \
           s6hugo /bin/sh -c "hugo new site site-name"
```

### hrun utility

Both of the commands above are captured in the [`hrun`](./hrun) utility script for convenience. Just drop it somewhere in your `PATH`, and you're good to go.

Since I usually have this repo available, I just link it into `/usr/local/bin`.

```sh
ln -s "$(pwd)/hrun" /usr/local/bin/hrun
```

If you're the trusting type, you can just pull it down directly from github.

```sh
(cd /usr/local/bin && curl -LO "https://raw.githubusercontent.com/blitterated/hugo-dde/master/hrun" && chmod +x hrun)
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
