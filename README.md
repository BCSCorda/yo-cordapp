![Corda](https://www.corda.net/wp-content/uploads/2016/11/fg005_corda_b.png)

# Yo! CorDapp on docker

**NOTE:**  This CorDapp targets Corda v3.1.

Send Yo's! to all your friends running Corda nodes!

Please refer [yo-cordapp](https://github.com/corda/yo-cordapp) for the yo-cordapp's documentation

This repository contains docker configuration files to create and spin up docker images for few corda nodes with a CorDapp running on corda-webserver.

The docker image is based on Alpine/OpenJDK (https://hub.docker.com/_/openjdk/) and this repository is tested with docker version 18.03.1-ce.

# Running the nodes locally in docker containers

1. `./gradlew deployNodes` - building may take upto a minute (it's much quicker if you already have the Corda binaries).
2. `docker swarm init` - Initialize a swarm 
3. `docker network create -d overlay --subnet=10.0.9.0/22 --attachable overlay-network` - Create a subnet of your own
4. Specify static ip address of your choice for the containers/nodes in docker-compose.yml
5. Edit nodes' names and ip addresses in `bootstrapnodes/nodes.sh` file and ensure it is the same as specified in docker-compose file for each node.
6. Mention the nodes' build folder location in .env file
7. `cd bootstrapnodes`
8. `./deployNodes.sh` - Run deployNodes script. This runs a series of commands to generate the nodes with the specified ip address.
9. `cd ..` - Exit bootstrapnodes folder.
10. `docker-compose build` - Need to run only once and afterwards only if there is a change in the Dockerfile, run this command.
11. `docker-compose up`

**NOTE:**  
```
Docker swarm is currently used to assign static ip address to run the containers in the local machine. If not, containers will not be able to communicate with each other in the local machine.  

Bootstraping the nodes is required because there is no provision to specify p2p and web address as part of deployNodes in build.gradle. 
In later versions of Corda, if we get an option to specify ipaddress for p2p and web like rpc, we can remove bootstrapnodes folder and ignore running ./deployNodes.sh command.
```

# Docker-izing any CorDapp

1. Specify the build folder location of your project in the .env file.
2. Define your app’s environment with a Dockerfile so it can be reproduced anywhere or reuse what is available in this project
3. Define the nodes that make up your app in docker-compose.yml. Copy the docker-compose file from this project and edit the node infos.
4. Edit nodes' names and ip addresses in `bootstrapnodes/nodes.sh` file and ensure it is the same as specified in docker-compose file for each node.


# Helpful Docker commands 

1. `docker-compose build` - Build base Corda images for Corda nodes
2. `docker-compose up` - Spin up all Corda containers 
3. `docker stop $(docker ps -q)` - Stop the containers
4. `docker rm $(docker ps -a -q)` - Remove the containers
5. `docker exec -t -i <node name> /bin/bash` - To access docker container bash


## Interacting with the CorDapp via HTTP

Please refer [yo-cordapp](https://github.com/corda/yo-cordapp) for the cordapp's documentation

Specify the value for target as `target=PartyB` instead of `target=O=PartyB`

## Using the RPC Client

Please refer [yo-cordapp](https://github.com/corda/yo-cordapp) for the cordapp's documentation

## Reference

Docker and docker-compose.yml files were taken from [corda-docker](https://github.com/corda/corda-docker/blob/master/README.md) and modified to work with Corda 3.1.

## Further reading

Tutorials and developer docs for CorDapps and Corda are [here](https://docs.corda.net/).
