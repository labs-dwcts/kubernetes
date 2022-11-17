# Kubernetes Installation on Ubuntu 20.04

## master node

Use `wget` or `curl`

### wget

```
wget -qO- https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/master.sh | sudo bash
```

### curl

```
curl -L https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/master.sh | sudo bash
```

## worker node

Use `wget` or `curl`

### wget

```
wget -qO- https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/worker.sh | sudo bash
```

### curl

```
curl -L https://raw.githubusercontent.com/labs-dwcts/kubernetes/main/install/worker.sh | sudo bash
```