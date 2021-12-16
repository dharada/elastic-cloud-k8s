### A tutorial 

#### 1. Create gke cluster

```commandline
CLUSTER_NAME=<cluster_name>
ZONE_NAME=<zone_name>
PROJECT_NAME=<project_name>
MACHINE_TYPE=e2-standard-4

gcloud container clusters create $CLUSTER_NAME --project $PROJECT_NAME --zone $ZONE_NAME --labels=label_a=xxxxx,label_b=xxxxxx --machine-type $MACHINE_TYPE
```

#### 2. Configure kubectl command line access by running the following command:

```commandline
gcloud container clusters get-credentials $CLUSTER_NAMsE --zone $ZONE_NAME --project $PROJECT_NAME
```


##### 3. set Role-based access control

```commandline
kubectl create clusterrolebinding \
cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
```

##### 4. create Custom Resource Definitions and apply operator
```commandline
kubectl create -f https://download.elastic.co/downloads/eck/1.9.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.9.0/operator.yaml
```
* please check newest custom resouce definition on official ECK docs. https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-eck.html

##### 5. apply ES(with LB), Kibana(with LB), Apm 
```commandline
kubectl apply -f quickstart-eck-with-lb.yaml
```

##### 6. display svc detail as yaml
```commandline
kubectl get service kibana-quickstart-kb-http -o yaml
```

##### 7. display statefulset/elastic-operato detail as yaml
```commandline
kubectl get statefulset elastic-operator --namespace elastic-system -o yaml
```

##### 8. check ES endpoint 

```commandline
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
ES_EXTERNAL_IP=$(kubectl get svc quickstart-es-http -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -u "elastic:$PASSWORD" -k "https://$ES_EXTERNAL_IP:9200"
```

##### 9. check Kibana endpoint 

```commandline
PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o=jsonpath='{.data.elastic}' -n default | base64 --decode)
KI_EXTERNAL_IP=$(kubectl get svc kibana-quickstart-kb-http -o=jsonpath='{.status.loadBalancer.ingress[0].ip}' -n default)
curl -u "elastic:${PASSWORD}" -k "https://${KI_EXTERNAL_IP}:5601/api/status" | jq .
```

##### 10. delete(clean up)
```commandline
kubectl delete -f quickstart-eck-with-lb.yaml
```

```commandline
kubectl delete -f https://download.elastic.co/downloads/eck/1.8.0/operator.yaml
kubectl delete -f https://download.elastic.co/downloads/eck/1.8.0/crds.yaml
```

