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

##### 3. create Custom Resource Definitions and apply operator
```
kubectl create -f https://download.elastic.co/downloads/eck/1.8.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.8.0/operator.yaml
```
* please check newest custom resouce definition on official ECK docs. https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-eck.html

##### 4. apply ES(with LB), Kibana(with LB), Apm 
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

##### 7. check ES endpoint 

```
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
ES_EXTERNAL_IP=$(kubectl get svc quickstart-es-http -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -u "elastic:$PASSWORD" -k "https://$ES_EXTERNAL_IP:9200"
```

##### 8. check Kibana endpoint 

```
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' -n default | base64 --decode)
KI_EXTERNAL_IP=$(kubectl get svc kibana-quickstart-kb-http -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n default)
curl -u "elastic:${PASSWORD}" -k "https://${KI_EXTERNAL_IP}:5601/api/status" | jq .
```

##### 9. delete(clean up)
```
kubectl delete -f quickstart-eck-with-lb.yaml
```

```
kubectl delete -f https://download.elastic.co/downloads/eck/1.8.0/operator.yaml
kubectl delete -f https://download.elastic.co/downloads/eck/1.8.0/crds.yaml
```

