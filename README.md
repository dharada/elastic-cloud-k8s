### A tutorial 

#### 1. Configure kubectl command line access by running the following command:

```
gcloud container clusters get-credentials <cluster_name> --zone <zone_name> --project <gke_project_name>
```


##### 2. set Role-based access control

```
kubectl create clusterrolebinding \
cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
```

##### 3. apply Custom Resource 
```
kubectl apply -f https://download.elastic.co/downloads/eck/1.0.1/all-in-one.yaml
```

##### 4. apply ES, Kibana(with LB), Apm 
```
kubectl apply -f quickstart-eck-with-lb.yaml
```

##### 5. display svc detail as yaml
```
kubectl get service kibana-quickstart-kb-http -o yaml
```

##### 6. display statefulset/elastic-operato detail as yaml
```
kubectl get statefulset elastic-operator --namespace elastic-system -o yaml
```

##### 7. check <EXTERNAL-IP>

```
kubectl get service
kubectl get service quickstart-es-http
```

##### 8. check ES endpoint 

```
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
```

```
curl -u "elastic:$PASSWORD" -k "https://<EXTERNAL-IP>:9200"
```

##### 9. delete(clean up)
```
kubectl delete -f quickstart-eck-with-lb.yaml
kubectl delete -f https://download.elastic.co/downloads/eck/1.0.1/all-in-one.yaml
```
