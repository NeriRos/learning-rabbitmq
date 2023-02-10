#!/bin/zsh

if [ $# -eq 0 ]; then
  echo >&2 "RabbitMQ Cluster name is required"
  exit 1
fi

echo "Creating perf-test for cluster: $1"

if ! (kubectl scripts version | grep -q error); then
  kubectl scripts perf-test "$1"
else
  username="$(kubectl get secret "$1-default-user" -o jsonpath='{.data.username}' | base64 --decode)"
  password="$(kubectl get secret "$1-default-user" -o jsonpath='{.data.password}' | base64 --decode)"
  service="$(kubectl get service "$1" -o jsonpath='{.spec.clusterIP}')"

  kubectl run perf-test --image=pivotalrabbitmq/perf-test -- --uri "amqp://$username:$password@$service"

  echo "Should display sent test messages for 5 seconds"

  kubectl logs --follow perf-test &

  pid=$!

  kubectl get pods | grep perf-test

  sleep 5

  kubectl delete pod "$(kubectl get pods | grep perf-test | cut -d ' ' -f1)"

  wait $pid
fi
