#!/usr/bin/env bash

set -e

NAMESPACE=${NAMESPACE:-default}
KNATIVE_VERSION=${KNATIVE_VERSION:-0.19.0}
KNATIVE_NET_KOURIER_VERSION=${KNATIVE_NET_KOURIER_VERSION:-0.19.0}

kubectl apply -f https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-crds.yaml
kubectl apply -f https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-core.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-serving
kubectl apply --filename https://github.com/knative/net-kourier/releases/download/v$KNATIVE_VERSION/kourier.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n kourier-system
# deployment for net-kourier gets deployed to namespace knative-serving
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-serving

kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'
 
kubectl --namespace kourier-system get service kourier

kubectl apply --filename https://github.com/knative/serving/releases/download/v$KNATIVE_VERSION/serving-default-domain.yaml

kubectl get pods --namespace knative-serving

kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n tekton-pipelines
kubectl get pod -n tekton-pipelines

cat <<EOF | kubectl apply -f -
apiVersion: serving.knative.dev/v1 # Current version of Knative
kind: Service
metadata:
  name: helloworld # The name of the app
  namespace: default # The namespace the app will use
spec:
  template:
    spec:
      containers:
        - image: gcr.io/knative-samples/helloworld-go # The URL to the image of the app
          env:
            - name: TARGET # The environment variable printed out by the sample app
              value: " ,Welocme to Knative Setup"
EOF
#kubectl wait ksvc helloworld --all --timeout=-1s --for=condition=Ready
SERVICE_URL=$(kubectl get ksvc helloworld -o jsonpath='{.status.url}')
echo "The SERVICE_ULR is $SERVICE_URL"
curl $SERVICE_URL

# Knative eventing installation

kubectl apply --filename https://github.com/knative/eventing/releases/download/v$KNATIVE_VERSION/eventing-crds.yaml
kubectl apply --filename https://github.com/knative/eventing/releases/download/v$KNATIVE_VERSION/eventing-core.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing
kubectl apply --filename https://github.com/knative/eventing/releases/download/v$KNATIVE_VERSION/in-memory-channel.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing
kubectl apply --filename https://github.com/knative/eventing/releases/download/v$KNATIVE_VERSION/mt-channel-broker.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing
kubectl apply --filename https://github.com/knative-sandbox/eventing-kafka/releases/download/v$KNATIVE_VERSION/source.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing
kubectl apply --filename https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/v$KNATIVE_VERSION/eventing-kafka-controller.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing
kubectl apply --filename https://github.com/knative-sandbox/eventing-kafka-broker/releases/download/v$KNATIVE_VERSION/eventing-kafka-sink.yaml
kubectl wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n knative-eventing

kubectl apply -f - <<EOF
apiVersion: eventing.knative.dev/v1
kind: broker
metadata:
 name: default
 namespace: $NAMESPACE
EOF

sleep 3

kubectl -n $NAMESPACE get broker default

kubectl -n knative-eventing get all