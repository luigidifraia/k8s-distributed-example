#!/bin/bash

kubectl logs -l "app=varnish-cache" -n dictionary-server
