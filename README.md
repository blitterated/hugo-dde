Want to build a Hugo static site while keeping all the dev dependencies separate from your host machine? This is the repo for you.

### Features

* `hugo server` runs as an [s6](https://skarnet.org/software/s6/overview.html) service via [s6-overlay](https://github.com/just-containers/s6-overlay).
* All Hugo and npm related dependencies are confined to the docker image.
* An open shell prompt for running adhoc `hugo` or `npm` commands in the container is available.
* Source code for the website is bind mounted from the host allowing use of host's IDEs.

### Requirements

This image builds on the [Docker Dev Environment](https://github.com/blitterated/docker_dev_env) image. Make sure that one is already built and available on your host.

## Usage

### Build an image

```sh
docker build -t hugo-dde .
```

__NOTE:__ It's important for the `hrun` utility that the image is named `hugo-dde`

### Run the image

See the [hrun](#hrun) section for installation instructions.

```sh
hrun
```

or

```sh
hrun start
```

### Create a new hugo site

See the [hrun](#hrun) section for installation instructions.

```sh
hrun new my-new-hugo-thing
```

## Utility Scripts

### Host

#### hrun

The commands from above for running the image as a server or creating a new site are captured in the [`hrun`](./utils/host/hrun) utility script for convenience. Just drop it somewhere in your `PATH`, and you're good to go.

Since I usually have this repo available, I just link it into `/usr/local/bin` on the host.

```sh
ln -s "$(pwd)/utils/host/hrun" /usr/local/bin/hrun
```

If you're the trusting type, you can just pull it down directly from github to the host.

```sh
(cd /usr/local/bin && curl -LO "https://raw.githubusercontent.com/blitterated/hugo-dde/master/utils/host/hrun" && chmod +x hrun)
```

### Container

This image inherits [`bounce`](https://github.com/blitterated/docker_dev_env#bounce), [`path`](https://github.com/blitterated/docker_dev_env#path), and [`docker-s6-quick-exit / qb`](https://github.com/blitterated/docker_dev_env#docker-s6-quick-exit--qb) from the base  [DDE](https://github.com/blitterated/docker_dev_env) image.

The `bounce` command is helpful when the Hugo server misses a file addition. Stopping and restarting the Hugo server with `bounce` will pick it up.

## Manual Operations

If you prefer not to use `hrun`, this is essentially what it does.

### Run the image

```sh
docker run -it --rm --name hugo-docker-s6 \
           -v "$(pwd)":/blog \
           -w /blog \
           -p 1313:1313 \
           hugo-dde
```

__NOTE:__ This depends on `blog/` being passed into `hugo server` with the `-s` switch in the s6 [`run`](./run#L2) script.

### Create a new hugo site

It's a little hacky, but you need to override the Entrypoint and the Command on the command line. It will exit immediately after creating the new site.

```sh
docker run --rm --name hugo-new-site \
           -v "$(pwd)":/blog \
           -w /blog \
           --entrypoint "" \
           hugo-dde /bin/sh -c "hugo new site site-name"
```
