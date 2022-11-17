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