# Lab 01 — Pods

## Goal

Understand the smallest deployable unit in Kubernetes: the **Pod**.

By the end of this lab, students should be able to:

- Create a Pod from YAML
- Inspect a Pod
- View Pod logs
- Execute commands inside a container
- Understand Pod IPs
- Delete and recreate Pods
- Create a multi-container Pod

## 1. Check the cluster

```bash
kubectl get nodes
```

## 2. Create your first Pod

```bash
kubectl apply -f pod.yaml
```

Check it:

```bash
kubectl get pods
kubectl get pods -o wide
```

Detailed information:

```bash
kubectl describe pod nginx-pod
```

## 3. Test the container

```bash
kubectl logs nginx-pod
```

Get the Pod IP:

```bash
kubectl get pod nginx-pod -o wide
```

Execute a command:

```bash
kubectl exec nginx-pod -- nginx -v
```

Open a shell:

```bash
kubectl exec -it nginx-pod -- /bin/sh
```

Inside the container:

```bash
hostname
cat /etc/os-release
exit
```

## 4. Port-forward

From the EC2 instance:

```bash
kubectl port-forward pod/nginx-pod 8080:80 --address 0.0.0.0
```

In another terminal:

```bash
curl http://127.0.0.1:8080
```

For browser access, allow TCP 8080 in the EC2 Security Group only from your IP, then browse:

```text
http://<EC2_PUBLIC_IP>:8080
```

Stop port-forwarding with `Ctrl+C`.

## 5. Multi-container Pod

```bash
kubectl apply -f multi-container-pod.yaml
kubectl get pod multi-container-pod
```

See the containers:

```bash
kubectl get pod multi-container-pod \
  -o jsonpath='{.spec.containers[*].name}{"\n"}'
```

Logs from a specific container:

```bash
kubectl logs multi-container-pod -c nginx
kubectl logs multi-container-pod -c sidecar
```

## 6. Environment variables

```bash
kubectl apply -f pod-with-env.yaml
kubectl exec env-pod -- printenv APP_ENV
kubectl exec env-pod -- printenv APP_VERSION
```

## Exercises

### Exercise 1

Change the image from:

```yaml
nginx:1.27
```

to another NGINX tag.

Apply the change and verify the Pod.

### Exercise 2

Delete the Pod:

```bash
kubectl delete pod nginx-pod
```

What happens?

Does Kubernetes recreate it?

> No. A standalone Pod is not managed by a controller.

### Exercise 3

Create a Pod with two containers that share an `emptyDir` volume.

This concept will be revisited in the Storage module.

## Cleanup

```bash
kubectl delete -f .
```
