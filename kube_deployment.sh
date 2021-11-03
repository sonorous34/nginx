#!/bin/bash

NS_CHECK=""
K8S_NAMESPACE="cicd"
K8S_DEPLOYMENT="nginx-deployment.yaml"

NS_CHECK=$(kubectl get ns |grep ${K8S_NAMESPACE} | awk '{print $1}')
echo "NS_CHECK: ${NS_CHECK}"

if [ -z ${NS_CHECK} ]||[ !${NS_CHECK} == 'cicd' ] ; then
  kubectl create ns ${K8S_NAMESPACE}
  kubectl -n ${K8S_NAMESPACE} create secret generic ${K8S_SECRET} -from-literal=username=jenkins --from-literal=password='admin1234!'
fi

kubectl -n ${K8S_NAMESPACE} apply -f ${K8S_DEPLOYMENT}
