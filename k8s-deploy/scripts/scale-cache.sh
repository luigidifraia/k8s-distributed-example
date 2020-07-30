#!/bin/bash

if [ -z "$1" ]; then
  echo "No argument supplied"
  exit 1
fi

replica_count=$1

kubectl patch deployment varnish-cache \
  --namespace dictionary-server \
  -p "{\"spec\": {\"replicas\": ${replica_count}}}"
