# Distributed Systems with Kubernetes

This repo takes some of the example material from the book "Designing Distributed Systems", by Brendan Burns, and makes it available to use with Kubernetes 1.18.

# TL;DR

Assuming you are a developer using MicroK8s 1.18 with `ingress`, `dns` and `repository` components enabled, you can follow the workflows as per below.

Warning: Ensure IPv6 entries for `localhost` are disabled in `/etc/hosts` if you want access to the local repository to work :warning:

## Building the Docker image and publishing it to the local image repository

```bash
cd docker-build
docker build -t dictionary-server .
docker tag dictionary-server localhost:32000/dictionary-server
docker push localhost:32000/dictionary-server
```

Check that the image was published:

```bash
curl -X GET http://localhost:32000/v2/_catalog
```

## Deploying the distributed system

Note: `kubectl` would be an alias for `microk8s.kubectl` when working with MicroK8s.

```bash
cd ../k8s-deploy
kubectl create ns dictionary-server
kubectl apply -f dictionary-deploy.yaml
kubectl apply -f dictionary-service.yaml
kubectl create configmap varnish-config -n dictionary-server --from-file=default.vcl
kubectl apply -f varnish-deploy.yaml
kubectl apply -f varnish-service.yaml
kubectl apply -f varnish-ingress.yaml
```

Patch the host used in the ingress for Varnish:

```bash
HOST=example.com
kubectl patch ingress varnish-ingress -n dictionary-server --type='json' -p="[{\"op\": \"replace\", \"path\": \"/spec/rules/0/host\", \"value\":\"${HOST}\"}]"
```

Now lookup a word's definition by accessing http://${HOST}/search/word
