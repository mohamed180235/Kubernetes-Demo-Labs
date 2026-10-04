# Lab 02 — Deployments

## Goal

Learn how Deployments manage replicated Pods and provide declarative application updates.

You will practice:

- Creating a Deployment
- Scaling replicas
- Updating an image
- Rolling updates
- Rollbacks
- Inspecting ReplicaSets
- Understanding self-healing

## 1. Create the Deployment

```bash
kubectl apply -f deployment.yaml
```

Check:

```bash
kubectl get deployment
kubectl get replicasets
kubectl get pods -o wide
```

## 2. Understand the hierarchy

```text
Deployment
    |
    v
ReplicaSet
    |
    +---- Pod
    +---- Pod
    +---- Pod
```

Inspect:

```bash
kubectl describe deployment nginx-deployment
```

## 3. Scale the application

```bash
kubectl scale deployment nginx-deployment --replicas=5
```

Verify:

```bash
kubectl get pods
kubectl get deployment
```

Scale down:

```bash
kubectl scale deployment nginx-deployment --replicas=2
```

## 4. Self-healing

Find a Pod:

```bash
kubectl get pods
```

Delete one:

```bash
kubectl delete pod <POD_NAME>
```

Watch:

```bash
kubectl get pods -w
```

A new Pod should be created because the Deployment maintains the desired replica count.

## 5. Rolling update

Check the current image:

```bash
kubectl get deployment nginx-deployment \
  -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

Update it:

```bash
kubectl set image deployment/nginx-deployment \
  nginx=nginx:1.28
```

Watch the rollout:

```bash
kubectl rollout status deployment/nginx-deployment
```

Inspect:

```bash
kubectl rollout history deployment/nginx-deployment
```

## 6. Rollback

```bash
kubectl rollout undo deployment/nginx-deployment
```

Verify:

```bash
kubectl rollout status deployment/nginx-deployment
```

## Exercises

### Exercise 1 — Scale

Scale the Deployment to 6 replicas.

### Exercise 2 — Update

Change the image to another valid NGINX version.

Observe the old and new Pods during the rollout:

```bash
kubectl get pods -w
```

### Exercise 3 — Break and recover

Change the image to a deliberately invalid image:

```text
nginx:this-image-does-not-exist
```

Observe:

```bash
kubectl get pods
kubectl describe pod <POD_NAME>
```

Then recover using:

```bash
kubectl rollout undo deployment/nginx-deployment
```

## Cleanup

```bash
kubectl delete -f .
```
