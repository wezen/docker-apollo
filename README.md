# WebApollo 2.0

![WebApollo Logo](http://gmod.org/mediawiki/images/thumb/4/4a/WebApolloLogo.png/400px-WebApolloLogo.png)

From the [GMOD Wiki](http://gmod.org/wiki/WebApollo)

> WebApollo is a browser-based tool for visualisation and editing of sequence
> annotations. It is designed for distributed community annotation efforts,
> where numerous people may be working on the same sequences in geographically
> different locations; real-time updating keeps all users in sync during the
> editing process.

## Running the Container

The container is publicly available as `erasche/webapollo2`. The recommended
method for launching the container is via docker-compose due to a dependency
on a postgres image.

```yaml
webapollo2:
  build: .
  links:
   - db
  ports:
   - "8080:8080"
  environment:
    WEBAPOLLO_DB_USERNAME: postgres
    WEBAPOLLO_DB_PASSWORD: password
    WEBAPOLLO_DB_DRIVER: "org.postgresql.Driver"
    WEBAPOLLO_DB_DIALECT: "org.hibernate.dialect.PostgresPlusDialect"
    WEBAPOLLO_DB_URI: "jdbc:postgresql://${DB_1_PORT_5432_TCP_ADDR}/postgres"
db:
  image: postgres
  environment:
    POSTGRES_PASSWORD: password

```

There are a large number of environment variables that can be adjusted to
suit your site's needs. These can be seen in the
[apollo-config.groovy](https://github.com/GMOD/Apollo/blob/master/sample-docker-apollo-config.groovy)
file.
