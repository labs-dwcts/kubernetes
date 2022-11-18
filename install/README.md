# Kubernetes Installation on Ubuntu 20.04

## master node

Use `wget` or `curl`

### wget

```
wget -qO- https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/master.sh | bash
```

### curl

```
curl -L https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/master.sh | bash
```

## worker node

Use `wget` or `curl`

### wget

```
wget -qO- https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/worker.sh | bash
```

### curl

```
curl -L https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/worker.sh | bash
```

### join token

Run this on any machine you wish to join an existing cluster.

master node

```
cat ~/.kube/kubeadm-join.txt
```

```
kubeadm join [api-server-endpoint] [flags]
```