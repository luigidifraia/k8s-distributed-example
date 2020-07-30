#!/bin/bash

kubectl logs -l "app=dictionary-server" -n dictionary-server
