# Apollo

![Apollo Logo](https://github.com/GMOD/docker-apollo/raw/master/img/ApolloLogo_100x36.png)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.268535.svg)](https://doi.org/10.5281/zenodo.268535)


> Apollo is a browser-based tool for visualisation and editing of sequence
> annotations. It is designed for distributed community annotation efforts,
> where numerous people may be working on the same sequences in geographically
> different locations; real-time updating keeps all users in sync during the
> editing process.

## Running the Container

The container is publicly available as `gmod/apollo:stable`. The recommended
method for launching the container is via docker-compose due to a dependency on
a postgres image.

There are a large number of environment variables that can be adjusted to suit
your site's needs. These can be seen in the
[apollo-config.groovy](https://github.com/GMOD/Apollo/blob/master/sample-docker-apollo-config.groovy)
file.

## Quickstart

This procedure starts tomcat in a standard virtualized environment with a PostgreSQL database with [Chado](http://gmod.org/wiki/Introduction_to_Chado).

- Install [docker](https://docs.docker.com/engine/installation/) for your system if not previously done.
- `docker run -it -p 8888:8080 gmod/apollo:2.0.6` # for a tested release
- `docker run -it -p 8888:8080 gmod/apollo:latest` # for the latest, remember to ```docker pull gmod/apollo``` to fetch newer versions
- `docker run -it -p 8888:8080 gmod/apollo:apollo-only` # from apollo only (no postgresql)
- `docker run -it -v /jbrowse/root/directory/:/data -p 8888:8080 gmod/apollo:latest`
- `docker run -it -v /jbrowse/root/directory/:/data  -p 8888:8080 quay.io/gmod/docker-apollo` # built by quay.io
- Apollo will be available at [http://localhost:8888/](http://localhost:8888/) (or 8888 if you don't configure the port)

When you use the above mount directory ```/jbrowse/root/directory``` and your genome is in 
```/jbrowse/root/directory/myawesomegenome``` you'll point to the directory: ```/data/myawesomegenome```.

### Logging In

The default credentials in this image are:

| Credentials |                    |
| ---         | ------------------ |
| Username    | `admin@local.host` |
| Password    | `password`         |


### Loading Data

Some sample data is baked into the container for you to play around with:

![](./img/sample.png)

### Chado

Chado support is now baked into the GMOD docker container image.
