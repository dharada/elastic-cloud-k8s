#!/bin/bash

echo "deploy a ECK clsuter to elastic-support-k8s-dev project"

if [ $# -ne 2 ]; then
  echo "invalid args. args count is $#" 1>&2
  echo "valid args is 2. cluster_name and zone_name" 1>&2
  exit 1
fi

cluster_name=$1
zone_name=$2

echo cluster_name=$cluster_name
echo zone_name=$zone_name


#### 1. Configure kubectl command line access by running the following command:

gcloud container clusters get-credentials $cluster_name --zone $zone_name --project elastic-support-k8s-dev

##### 2. set Role-based access control

kubectl create clusterrolebinding \
cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")


kubectl apply -f https://download.elastic.co/downloads/eck/1.0.1/all-in-one.yaml

kubectl apply -f ./quickstart-eck-with-lb.yaml


sleep 5

kubectl get service


