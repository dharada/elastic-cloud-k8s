### A tutorial (for deploy es, kibana, logstash, beats on GKE manually)

#### 1. to prepare storage
```commandline
gcloud compute disks create disk1-daisuke-k8s --zone=asia-east1-a --type pd-balanced --size 10GB --project "elastic-support-k8s-dev"
```
* please adjust parameters (disk name, --tyep, --size etc) as you like.

#### 2. to check the storage
```commandline
gcloud compute disks list --project "elastic-support-k8s-dev" | grep disk1-daisuke-k8s
```

#### 3. to create PersistentVolume and PersistentVolumeClaim

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: es-manual-pv
  labels:
    app: es-manual-pv
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  gcePersistentDisk:
    pdName: disk1-daisuke-k8s
    fsType: ext4
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: es-manual-pvc
  labels:
    app: es-manual-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ""
  resources:
    requests:
      storage: 5Gi
  selector:
    matchLabels:
      app: es-manual-pv
```
* please adjust metadata and spec to match your needs.



### To expose kibana deployment

```commandline
kubectl expose deployment kibana-manual --type LoadBalancer --port 5601 --dry-run=client
kubectl expose deployment kibana-manual --type LoadBalancer --port 5601
```

### configMap for Logstash

```commandline
kubectl create configmap logstash-manual-pipeline --from-file ./logstash-a-pipeline.conf

(When you want to delete)
kubectl delete configmap logstash-manual-pipeline
```

### To expose logstash input port from beats
```commandline
kubectl expose deployment logstash-manual --type LoadBalancer --port 5044 --dry-run=client
kubectl expose deployment logstash-manual --type LoadBalancer --port 5044
```
