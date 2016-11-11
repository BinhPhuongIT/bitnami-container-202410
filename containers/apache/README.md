[![CircleCI](https://circleci.com/gh/bitnami/bitnami-docker-apache/tree/master.svg?style=shield)](https://circleci.com/gh/bitnami/bitnami-docker-apache/tree/master)
[![Docker Hub Automated Build](http://container.checkforupdates.com/badges/bitnami/apache)](https://hub.docker.com/r/bitnami/apache/)


# What is Apache?

> The Apache HTTP Server Project is an effort to develop and maintain an open-source HTTP server for modern operating systems including UNIX and Windows NT. The goal of this project is to provide a secure, efficient and extensible server that provides HTTP services in sync with the current HTTP standards.

[http://httpd.apache.org/](http://httpd.apache.org/)

# TLDR

```bash
docker run --name apache bitnami/apache:latest
```

## Docker Compose

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:80'
      - '443:443'
```

# Get this image

The recommended way to get the Bitnami Apache Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/bitnami/apache).

```bash
docker pull bitnami/apache:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/bitnami/apache/tags/) in the Docker Hub Registry.

```bash
docker pull bitnami/apache:[TAG]
```

If you wish, you can also build the image yourself.

```bash
docker build -t bitnami/apache:latest https://github.com/bitnami/bitnami-docker-apache.git
```

# Hosting a static website

The `/app` path is configured as the Apache [DocumentRoot](https://httpd.apache.org/docs/2.4/urlmapping.html#documentroot). Content mounted here is served by the default catch-all virtual host.

```bash
docker run --name apache -v /path/to/app:/app bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/app:/app
```

# Accessing your server from the host

To access your web server from your host machine you can ask Docker to map a random port on your host to ports `80` and `443` exposed in the container.

```bash
docker run --name apache -P bitnami/apache:latest
```

Run `docker port` to determine the random ports Docker assigned.

```bash
$ docker port apache
443/tcp -> 0.0.0.0:32768
80/tcp -> 0.0.0.0:32769
```

You can also manually specify the ports you want forwarded from your host to the container.

```bash
docker run -p 8080:80 -p 8443:443 bitnami/apache:latest
```

Access your web server in the browser by navigating to [http://localhost:8080](http://localhost:8080/).

# Configuration

## Adding custom virtual hosts

The default `httpd.conf` includes virtual hosts placed in `/bitnami/apache/conf/vhosts/*.conf`. You can mount a directory at `/bitnami/apache/conf/vhosts` from your host containing your custom virtual hosts.

```bash
docker run \
  -v /path/to/apache-persistence/vhosts:/bitnami/apache/conf/vhosts \
  bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/apache-persistence/vhosts:/bitnami/apache/conf/vhosts
```

## Using custom SSL certificates

*NOTE:* The steps below assume that you are using a custom domain name and that you have already configured the custom domain name to point to your server.

This container comes with SSL support already pre-configured and with a dummy certificate in place (`server.crt` and `server.key` files in `/bitnami/apache/conf/bitnami/certs`). If you want to use your own certificate (`.crt`) and certificate key (`.key`) files, follow the steps below:

### Step 1: Prepare your certificate files

In your local computer, create a folder called `certs` and put your certificates files. Make sure you rename both files to `server.crt` and `server.key` respectively:

```bash
mkdir /path/to/apache-persistence/conf/bitnami/certs -p
cp /path/to/certfile.crt /path/to/apache-persistence/conf/bitnami/certs/server.crt
cp /path/to/keyfile.key  /path/to/apache-persistence/conf/bitnami/certs/server.key
```

### Step 2: Run the Apache image

Run the Apache image, mounting the certificates directory from your host.

```bash
docker run --name apache \
  -v /path/to/apache-persistence/conf/bitnami/certs:/bitnami/apache/conf/bitnami/certs \
  bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/apache-persistence/conf/bitnami/certs:/bitnami/apache/conf/bitnami/certs
```

## Full configuration

This container looks for configuration in `/bitnami/apache/conf`. You can mount a directory at `/bitnami/apache/` with your own configuration, or the default configuration will be copied to your directory at `conf/` if it is empty.

### Step 1: Run the Apache image

Run the Apache image, mounting a directory from your host.

```bash
docker run --name apache \
  -v /path/to/apache-persistence:/bitnami/apache \
  bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/apache-persistence:/bitnami/apache
```

### Step 2: Edit the configuration

Edit the configuration on your host using your favorite editor.

```bash
vi /path/to/apache-persistence/conf/httpd.conf
```

### Step 4: Restart Apache

After changing the configuration, restart your Apache container for the changes to take effect.

```bash
docker restart apache
```

or using Docker Compose:

```bash
docker-compose restart apache
```

# Reverse proxy to other containers

Apache can be used to reverse proxy to other containers using Docker's linking system. This is particularly useful if you want to serve dynamic content through an Apache frontend.

**Further Reading:**

  - [mod_proxy documentation](http://httpd.apache.org/docs/2.2/mod/mod_proxy.html#forwardreverse)

# Logging

The Bitnami Apache Docker image sends the container logs to the `stdout`. To view the logs:

```bash
docker logs apache
```

or using Docker Compose:

```bash
docker-compose logs apache
```

You can configure the containers [logging driver](https://docs.docker.com/engine/admin/logging/overview/) using the `--log-driver` option if you wish to consume the container logs differently. In the default configuration docker uses the `json-file` driver.

# Maintenance

## Backing up your container

To backup your configuration, follow these simple steps:

### Step 1: Stop the currently running container

```bash
docker stop apache
```

or using Docker Compose:

```bash
docker-compose stop apache
```

### Step 2: Run the backup command

We need to mount two volumes in a container we will use to create the backup: a directory on your host to store the backup in, and the volumes from the container we just stopped so we can access the data.

```bash
docker run --rm -v /path/to/apache-backups:/backups \
  --volumes-from apache busybox \
    cp -a /bitnami/apache /backups/latest
```

or using Docker Compose:

```bash
docker run --rm -v /path/to/apache-backups:/backups \
  --volumes-from `docker-compose ps -q apache` busybox \
    cp -a /bitnami/apache /backups/latest
```

## Restoring a backup

Restoring a backup is as simple as mounting the backup as volumes in the container.

```bash
docker run \
  -v /path/to/apache-backups/latest:/bitnami/apache \
  bitnami/apache:latest
```

or using Docker Compose:

```yaml
version: '2'

services:
  apache:
    image: 'bitnami/apache:latest'
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - /path/to/apache-backups/latest:/bitnami/apache
```

## Upgrade this image

Bitnami provides up-to-date versions of Apache, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

### Step 1: Get the updated image

```bash
docker pull bitnami/apache:latest
```

or if you're using Docker Compose, update the value of the image property to
`bitnami/apache:latest`.

### Step 2: Stop and backup the currently running container

Before continuing, you should backup your container's configuration and logs.

Follow the steps on [creating a backup](#backing-up-your-container).

### Step 3: Remove the currently running container

```bash
docker rm -v apache
```

or using Docker Compose:

```bash
docker-compose rm -v apache
```

### Step 4: Run the new image

Re-create your container from the new image, [restoring your backup](#restoring-a-backup) if necessary.

```bash
docker run --name apache bitnami/apache:latest
```

or using Docker Compose:

```bash
docker-compose start apache
```

# Testing

This image is tested for expected runtime behavior, using the [Bats](https://github.com/sstephenson/bats) testing framework. You can run the tests on your machine using the `bats` command.

```
bats test.sh
```

# Notable Changes

## 2.4.18-r0

- All volumes have been merged at `/bitnami/apache`. Now you only need to mount a single volume at `/bitnami/apache` for persistence.
- The logs are always sent to the `stdout` and are no longer collected in the volume.

## 2.4.12-4-r01

- The `/app` directory is no longer exported as a volume. This caused problems when building on top of the image, since changes in the volume are not persisted between Dockerfile `RUN` instructions. To keep the previous behavior (so that you can mount the volume in another container), create the container with the `-v /app` option.

# Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitnami/bitnami-docker-apache/issues), or submit a [pull request](https://github.com/bitnami/bitnami-docker-apache/pulls) with your contribution.

# Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitnami/bitnami-docker-apache/issues). For us to provide better support, be sure to include the following information in your issue:

- Host OS and version
- Docker version (`docker version`)
- Output of `docker info`
- Version of this container (`echo $BITNAMI_IMAGE_VERSION` inside the container)
- The command you used to run the container, and any relevant output you saw (masking any sensitive information)

# License

Copyright (c) 2015-2016 Bitnami

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
