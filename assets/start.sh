#!/bin/bash

# Get the Environment variables and save them in the variable envs
envs=`printenv`

# Loop through all of our variables
for env in $envs
do
  # separate the name of the variable from the value
  IFS== read name value <<< "$env"

  # Replace each name with the corresponding value
  sed -i "s|\${${name}}|${value}|g" /conf/goji.conf
done

nginx

watch -n30 /goji/bin/goji -conf /conf/goji.conf
