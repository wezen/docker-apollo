# Apollo

![Apollo Logo](https://github.com/GMOD/Apollo/blob/master/web-app/images/ApolloLogo_100x36.png)

> Apollo is a browser-based tool for visualisation and editing of sequence annotations. It is designed for distributed community annotation efforts,
> where numerous people may be working on the same sequences in geographically different locations; real-time updating keeps all users in sync during the
> editing process.

## Running the Container

The container is publicly available as `gmod/apollo:stable`. The recommended
method for launching the container is via docker-compose due to a dependency
on a postgres image.   

There are a large number of environment variables that can be adjusted to suit your site's needs. These can be seen in the [apollo-config.groovy](https://github.com/GMOD/Apollo/blob/master/sample-docker-apollo-config.groovy) file.


## Quickstart

This procedure starts tomcat in a standard virtualized environment with a PostgreSQL database.

- Install [docker](https://docs.docker.com/engine/installation/) for your system if not previously done. 
- Start the docker-engine service using for your system (quickstart terminal for mac typically or start the docker-engine as a service for linux). 

- Clone docker: ```git clone https://github.com/GMOD/docker-apollo.git```
- ```cd docker-webapollo2```
- copy JBrowse data into ```docker-apollo/data``` OR copy all files into a root level folder and above jbrowse tracks and link the name data or change the filename in the ```docker-compose.yml``` file.
- ```docker-machine ls``` to get your IP
- ```eval "$(docker-machine env default)```  # this connects the shell to the machine!
- ```docker-compose up -d```  # starts the service as a daemon
- Connect to http://<docker-ip>:8080/apollo/ and confirm its working.  e.g., http://192.168.92.100:8080/apollo
- Copy JBrowse directories into appropriate mounted docker volumes (see ```docker-compose.yml``` for mounted volumes).  
- Begin working with Apollo as usual.  All directories in ```data``` are accessible in the docker file-system at ```/data/``` when you add directories.   Other similarly exposed directories are ```apollo``` and ```jbrowse```.

To connect to the running machine:
- ```docker ps```
- ```docker exec -it <container id, first column for the apollo container>```

To bring down a machine:
- ```docker-compose down```

##### Docker for production 

To add additional parameters to represent your production environment (e.g. ```restart: always```, additional volumes), you can add a production.yml file and include it:

```docker-compose -f docker-compose.yml -f production.yml up -d```

Please see [additional information about using docker in production](https://docs.docker.com/compose/production/).

