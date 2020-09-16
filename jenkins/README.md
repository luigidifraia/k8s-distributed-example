# TL;DR

Build the Docker image for Jenkins:

```bash
docker build -t localhost:32000/jenkins .
docker push localhost:32000/jenkins
```

Deploy Jenkins:

```bash
cd k8s
kubectl create ns jenkins
kubectl apply -f jenkins-deployment.yaml --namespace jenkins
kubectl apply -f jenkins-service.yaml --namespace jenkins
```
