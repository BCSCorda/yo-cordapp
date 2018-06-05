#!/usr/bin/env bash

source nodes.sh
source ../.env

#Copy node conf
printf "\e[1;34m1. Copying node.conf to bootstrap nodes.\e[0m\n"
for node in "${!nodes[@]}"
do
  printf "Copying .$path/$node/node.conf to bootstrap nodes.\n"
  cp .$path/$node/node.conf $node.conf
done

#Updating node.conf with their respective ip-addresses.
printf "\e[1;34m2. Updating node.conf files with their respective ip-addresses.\e[0m\n"
for k in "${!nodes[@]}"
do
 sed -i "s/localhost/${nodes[$k]}/g" $k.conf
done

#Generate nodes based on node.conf
printf "\e[1;34m3. Generating nodes based on node.conf.\e[0m\n"
java -jar network-bootstrapper-corda-3.1.jar .

#Copy nodes to build folder
printf "\e[1;34m4. Copy nodes to build folder(".$path").\e[0m\n"
for node in "${!nodes[@]}"
do
 printf "Copying generated files for $node to .$path folder.\n"
 cp -a $node/. .$path/$node/
done

#Remove files
printf "\e[1;34m5. Removing all node folders that were created.\e[0m\n"
for node in "${!nodes[@]}"
do
 rm -r $node
done
rm whitelist.txt
rm -r .cache
