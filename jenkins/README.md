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
kubectl apply -f jenkins-ingress.yaml --namespace jenkins
```

Patch the host used in the ingress for Jenkins, using [xip.io](http://xip.io/) to resolve custom domain names used for testing:

```bash
HOST=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p').xip.io

kubectl patch ingress jenkins -n jenkins --type='json' -p="[{\"op\": \"replace\", \"path\": \"/spec/rules/0/host\", \"value\":\"${HOST}\"}]"
```

If you were to use the [NGINX Ingress](https://kubernetes.github.io/ingress-nginx/) instead of the `ingress` addon, you'd have to change the first command with:

```bash
HOST=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}').xip.io
```
