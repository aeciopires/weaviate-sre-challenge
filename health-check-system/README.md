# health-check-system
<!-- TOC -->

- [health-check-system](#health-check-system)
- [About](#about)
- [Requirements](#requirements)
- [How to use](#how-to-use)
  - [Using make](#using-make)
  - [Using docker-compose](#using-docker-compose)
  - [Using python](#using-python)
- [Build and publish image](#build-and-publish-image)

<!-- TOC -->

# About

This is ``myhealthcheck`` app developed in [Python](https://www.python.org) to check the health another application. In this case, I used the [kube-pires](https://gitlab.com/aeciopires/kube-pires/-/tree/master/app), a simple application developed in [Golang](https://go.dev/) to show some informations about the container or pod.

# Requirements

- Install all packages and binaries following the instructions on the [REQUIREMENTS.md](../REQUIREMENTS.md) file.
- Tested only in Ubuntu 24.04/22.04 and MacOs 14.6.1 in ``amd64`` architecture.

> ATTENTION!!! The ``kube-pires`` application has support to ``linux/amd64`` only. If you use other operating system or architecture, maybe you need use other application to be monitored.

# How to use

- Clone this repository.

```bash
cd /tmp
git clone https://github.com/aeciopires/weaviate-sre-challenge.git
cd weaviate-sre-challenge/health-check-system
```

- Change the ``app/.env`` file according your environment.

- Run the program by choosing one of the subsections below.

## Using make

- Run stack ([kube-pires](https://gitlab.com/aeciopires/kube-pires/-/tree/master/app) app and ``myhealthchek`` program, using ``make``)

```bash
make up
```

- To see logs of all containers:

```bash
make logs
```

- To stop stack:

```bash
make down
```

## Using docker-compose

- Run stack ([kube-pires](https://gitlab.com/aeciopires/kube-pires/-/tree/master/app) app and ``myhealthchek`` program, using ``docker-compose``)

```bash
docker-compose up --build -d
```

- To see specific log of ``myhealthcheck``:

```bash
docker-compose logs -f myhealthcheck
```

- To stop stack:

```bash
docker-compose down
```

## Using python

- Run manually only ``myhealthchek`` program:

```bash
python app/main.py

# Or

python app/main.py -f app/.env
```

# Build and publish image

- Build image of ``myhealthchek`` program:

```bash
make image
```
