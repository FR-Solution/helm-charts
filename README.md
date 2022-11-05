### Lint the chart
```bash
helm lint helm-chart-sources/*
```


### Create the Helm chart package
```bash
helm package helm-chart-sources/* --destination helm-chart-revisions
```

### Create the Helm chart repository index
```bash
helm repo index --url https://helm.fraima.io/ .

```

### Push the git repository on GitHub
```bash
git add . && git commit -m "Initial commit" && git push origin main

```

### Helm repo  add/update
```bash
helm repo add fraima helm.fraima.io
helm repo update fraima
```

### Helm search  add/update
```bash
helm search repo fraima
```
