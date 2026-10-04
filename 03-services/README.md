# Lab 03 — Services

## Goal

Understand how Kubernetes Services provide stable networking to Pods.

You will practice:

- ClusterIP
- Service selectors
- DNS-based service discovery
- NodePort
- Port-forwarding
- LoadBalancer behavior in Kind

## Architecture

```text
             Service
          10.x.x.x:80
               |
       +-------+-------+
       |       |       |
      Pod     Pod     Pod
```

The Service selects Pods using labels.

## 1. Create the Deployment

```bash
kubectl apply -f deployment.yaml
```

Check labels:

```bash
kubectl get pods --show-labels
```

## 2. Create a ClusterIP Service

```bash
kubectl apply -f clusterip.yaml
```

Check:

```bash
kubectl get service
kubectl describe service nginx-service
```

Get endpoints:

```bash
kubectl get endpoints
```

On newer Kubernetes versions you can also use:

```bash
kubectl get endpointslices
```

## 3. Test the Service from inside the cluster

Create a temporary client:

```bash
kubectl run curl \
  --image=curlimages/curl:8.10.1 \
  -it --rm --restart=Never -- sh
```

Inside the temporary Pod:

```bash
curl http://nginx-service
```

Test DNS:

```bash
curl http://nginx-service.default.svc.cluster.local
```

Exit:

```bash
exit
```

## 4. Understand the selector

The Service contains:

```yaml
selector:
  app: nginx
```

The Pods contain:

```yaml
labels:
  app: nginx
```

Kubernetes uses this relationship to select the backend Pods.

Try changing the Service selector to a label that does not exist.

Then:

```bash
kubectl get endpoints nginx-service
```

You should see that the Service has no usable backends.

Restore the correct selector.

## 5. NodePort

Apply:

```bash
kubectl apply -f nodeport.yaml
```

Check:

```bash
kubectl get svc nginx-nodeport
```

Kind runs inside Docker, so direct NodePort access from the EC2 host is not always exposed automatically.

For a simple course demo, use port-forwarding:

```bash
kubectl port-forward service/nginx-service 8080:80 --address 0.0.0.0
```

Then:

```bash
curl http://127.0.0.1:8080
```

## 6. Service discovery

Create another Pod:

```bash
kubectl run dns-test \
  --image=busybox:1.36 \
  -it --rm --restart=Never -- sh
```

Inside:

```bash
nslookup nginx-service
```

Then:

```bash
wget -qO- http://nginx-service
```

Exit:

```bash
exit
```

## Exercises

### Exercise 1

Change the Service selector and observe the endpoints.

### Exercise 2

Scale the Deployment:

```bash
kubectl scale deployment nginx-deployment --replicas=5
```

Check:

```bash
kubectl get endpoints nginx-service
```

How did the Service change?

### Exercise 3

Delete one backend Pod:

```bash
kubectl delete pod <POD_NAME>
```

Watch the endpoints:

```bash
kubectl get endpoints nginx-service -w
```

What happens?

## Cleanup

```bash
kubectl delete -f .
```
