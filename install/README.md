# Kubernetes Installation on Ubuntu 20.04

## master node

You can install it using `wget` or `curl` .

### wget

```
wget -qO- https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/master.sh | bash
```

### curl

```
curl https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/master.sh | bash
```

## worker node

You can install it using `wget` or `curl` .

### wget

```
wget -qO- https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/worker.sh | bash
```

### curl

```
curl https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/worker.sh | bash
```

### join token

Run this on any machine you wish to join an existing cluster.

Check the `kubeadm-join.txt` file on master node.

```
cat ~/.kube/kubeadm-join.txt
```

Join the cluster using the join token.
```
kubeadm join [api-server-endpoint] [flags]
```