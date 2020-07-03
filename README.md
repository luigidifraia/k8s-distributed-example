# Distributed Systems with Kubernetes

This repo takes some of the example material from the book "Designing Distributed Systems", by Brendan Burns, and makes it available to use with Kubernetes 1.18.

# TL;DR

```bash
cd docker-build
docker build -t dictionary-server .
docker tag dictionary-server localhost:32000/dictionary-server
docker push localhost:32000/dictionary-server
curl -X GET http://localhost:32000/v2/_catalog

cd ../k8s-deploy
kubectl create ns dictionary-server
kubectl apply -f dictionary-deploy.yaml
kubectl apply -f dictionary-service.yaml
kubectl create configmap varnish-config -n dictionary-server --from-file=default.vcl
kubectl apply -f varnish-deploy.yaml
kubectl apply -f varnish-service.yaml
```
