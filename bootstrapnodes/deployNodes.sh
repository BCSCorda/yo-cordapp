#!/bin/bash

source nodes.properties
source ../.env

printf "\e[1;34m1. Copying node.conf to bootstrap nodes.\e[0m\n"
#Copy node conf
cp .$path/Notary/node.conf Notary.conf
cp .$path/PartyA/node.conf PartyA.conf
cp .$path/PartyB/node.conf PartyB.conf

printf "\e[1;34m2. Updating node.conf files with their respective ip-addresses.\e[0m\n"
#Updating node.conf with their respective ip-addresses.
sed -i "s/localhost/$notaryip/g" Notary.conf
sed -i "s/localhost/$partyAip/g" PartyA.conf
sed -i "s/localhost/$partyBip/g" PartyB.conf

#Generate nodes based on node.conf
printf "\e[1;34m3. Generating nodes based on node.conf.\e[0m\n"
java -jar network-bootstrapper-corda-3.1.jar .


#Copy nodes to build folder
printf "\e[1;34m4. Copy nodes to build folder("$path").\e[0m\n"
cp -a Notary/ .$path/Notary/
cp -a PartyA/ .$path/PartyA/
cp -a PartyB/ .$path/PartyB/

#Remove files
printf "\e[1;34m5. Removing all node folders that were created.\e[0m\n"
rm -r Notary
rm -r Party*
rm -r .cache
rm whitelist.txt
