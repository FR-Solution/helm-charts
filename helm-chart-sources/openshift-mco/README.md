### INSTALL the chart
```bash
helm upgrade --install machiine-config-operator . -n openshift-machine-config-operator      --create-namespace
```

#### Основное условие работы демонов, при старте узла в файловой системе должно существовать 2 файла

1) Базовая аннотация, которая будет применена к хосту (отправная точка конфигурации)
``` bash
cat <<EOF > /etc/machine-config-daemon/node-annotation.json
{"machineconfiguration.openshift.io/currentConfig":"rendered-default","machineconfiguration.openshift.io/desiredConfig":"rendered-default","machineconfiguration.openshift.io/state":"Done"}
EOF
```
2) Базовый конфиг, равный MC rendered-default (создается при установке чарта)
``` bash
cat <<EOF > /etc/machine-config-daemon/currentconfig
{"metadata":{"name":"rendered-default"},"spec":{"config":{"ignition":{"version":"3.2.0"}},"extensions":[],"fips":false,"kernelArguments":[],"kernelType":"default","osImageURL":""}}
EOF
```