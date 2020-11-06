#!/bin/bash

if [ -z "$1" ]; then
  echo "No argument supplied"
  exit 1
fi

replica_count=$1

kubectl scale deployment varnish-cache \
  --namespace dictionary-server \
  --replicas ${replica_count} --record
