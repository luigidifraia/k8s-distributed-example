# Distributed Systems with Kubernetes

This repo takes some of the example material from the book "Designing Distributed Systems", by Brendan Burns, and makes it available to use with Kubernetes 1.18.

# TL;DR

Assuming you are a developer using MicroK8s 1.18 with `ingress`, `dns` and `repository` components enabled, you can follow the workflows as per below.

Warning: Ensure IPv6 entries for `localhost` are disabled in `/etc/hosts` if you want access to the local repository to work :warning:

## Building the Docker image and publishing it to the local image repository

Feel free to use Docker Hub in order to publish and access your Docker images from multiple machines. However, for development purposes, when working on a single workstation you can also just use the local image repository, available on `localhost:32000` when using MicroK8s. The use of an image repository is not strictly necessary for using the deployment material provided in this repo with MicroK8s, but it gives users insights on how Docker images are deployed in a Kubernetes cluster.

```bash
cd docker-build
docker build -t localhost:32000/dictionary-server .
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

Patch the host used in the ingress for Varnish, using [xip.io](http://xip.io/) to resolve custom domain names used for testing:

```bash
HOST=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p').xip.io

kubectl patch ingress varnish-ingress -n dictionary-server --type='json' -p="[{\"op\": \"replace\", \"path\": \"/spec/rules/0/host\", \"value\":\"${HOST}\"}]"

echo "Now lookup a word's definition by accessing the URL: http://${HOST}/search/word"
```

If you were to use the [NGINX Ingress](https://kubernetes.github.io/ingress-nginx/) instead of the `ingress` addon, you'd have to change the first command with:

```bash
HOST=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}').xip.io
```
