### A tutorial 

1. set Role-based access control

```
kubectl create clusterrolebinding \
cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
```

1. apply Custom Resource 
```
kubectl apply -f https://download.elastic.co/downloads/eck/1.0.0-beta1/all-in-one.yaml
```

1. apply ES, Kibana(with LB), Apm 
```
kubectl apply -f https://github.com/dharada/elastic-cloud-k8s/blob/master/quickstart-eck-with-lb.yaml
```

1. display svc detail as yaml
```
kubectl get service kibana-quickstart-kb-http -o yaml
```

1. display statefulset/elastic-operato detail as yaml
```
kubectl get statefulset elastic-operator --namespace elastic-system -o yaml
```