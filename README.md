![Corda](https://www.corda.net/wp-content/uploads/2016/11/fg005_corda_b.png)

# Yo! CorDapp

**NOTE:** This CorDapp targets Corda v2.0.

Send Yo's! to all your friends running Corda nodes!

## Pre-Requisites

You will need the following installed on your machine before you can start:

* Latest [JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html) 
  installed and available on your path
* [IntelliJ IDEA](https://www.jetbrains.com/idea/download/) minimum version 2017.1
* git

## Getting Set Up

To get started, clone this repository with:

     git clone https://github.com/roger3cev/yo-cordapp.git

And change directories to the newly cloned repo:

     cd yo-cordapp

## Building the Yo! CorDapp:

**Unix:** 

     ./gradlew clean deployNodes

**Windows:**

     gradlew.bat clean deployNodes

## Running the Nodes:

Once the build finishes, change directories to the folder where the newly
built nodes are located:

**Kotlin:**

     cd build/nodes

**Java:**

     cd build/nodes

The Gradle build script will have created a folder for each node. You'll
see three folders, one for each node and a `runnodes` script. You can
run the nodes with:

**Unix:**

     ./runnodes

**Windows:**

    runnodes.bat

You should now have three Corda nodes running on your machine serving
the Yo! CorDapp.

Five windows will open in the terminal. One for each node's node shell, plus webservers for Party A and Party B.

# Running the nodes locally in docker containers

1. `./gradlew deployNodes` - building may take upto a minute (it's much quicker if you already have the Corda binaries).
2. `docker swarm init` - Initialize a swarm
3. `sudo docker network create -d overlay --subnet=10.0.9.0/22 --attachable overlay-network` - Create a subnet of your own
4. Specify static ip address of your choice for the containers/nodes in docker-compose.yml
5. Specify the given nodes' ip addresses in nodes.properties file.
6. Mention the nodes folder location in .env file
7. `cd bootstrapnodes`
8. `./deployNodes.sh` - Run deployNodes script. This runs a series of commands to generate the nodes with the specified ip address.
9. `cd ..` - Exit bootstrapnodes folder.
10. `docker-compose build` - Need to run only once and afterwards only if there is a change in the Dockerfile, run this command.
11. `docker-compose up`

NOTE: Docker swarm is currently used to assign static ip address to run the containers in the local machine. If not, containers will not be able to communicate with each other in the local machine.

# Docker commands that may be of use

1. `docker stop $(docker ps -q)` - Stop the containers
2. `docker rm $(docker ps -a -q)` - Remove the containers
3. `docker exec -t -i PartyA /bin/bash` - To access docker container bash


## Interacting with the CorDapp via HTTP

The Yo! CorDapp defines a couple of HTTP API end-points.

The nodes can be found using the following port numbers output in the web server
terminal window or in the `build.gradle` file.

     NodeA: localhost:10007
     NodeB: localhost:10010

Sending a Yo! from Party A to Party B (we use Party B's X500 organisation. You do not need to use the whole X500 name,
using only the organisation works. In this case: PartyA, PartyB, Controller, etc.):

    http://localhost:10007/api/yo/yo?target=PartyB

Showing all of Party B's Yo's!:

     http://localhost:10010/api/yo/yos
     
Finding out who Party B is:

    http://localhost:10010/api/yo/me

Finding out who Party B can send Yo's! to:

    http://localhost:10010/api/yo/peers

## Using the RPC Client

Use the gradle command (for Party A):

     ./gradlew runYoRPCNodeA
     
or (for Party B):
     
     ./gradlew runYoRPCNodeB

When running it should enumerate all previously received Yo's! as well as show any new Yo's! 
received when they are sent to you.

## Using the node shell

The node shell is a great way to test your CorDapps without having to create a user interface. 

When the nodes are up and running, use the following command to send a Yo! to another node:

    flow start YoFlow target: [NODE_NAME]
    
Where `NODE_NAME` is 'PartyA' or 'PartyB'. The space after the `:` is required. As with the web API, you are not 
required to use the full X500 name in the node shell. Note you can't sent a Yo! to yourself because that's not cool!

To see all the Yo's! in your vault:

    run vaultQuery contractStateType: net.corda.yo.YoState

## Further reading

Tutorials and developer docs for CorDapps and Corda are [here](https://docs.corda.net/).
