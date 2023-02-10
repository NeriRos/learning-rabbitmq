#!/bin/zsh

if [ $# -eq 0 ]; then
  echo >&2 "RabbitMQ Cluster name is required"
  exit 1
fi

echo "Getting RabbitMQ management username and password for cluster: $1"

if [ "$(kubectl rabbitmq version)" != "error*" ]; then
  kubectl rabbitmq manage "$1"
else
  username="$(kubectl get secret hello-world-default-user -o jsonpath='{.data.username}' | base64 --decode)"
  password="$(kubectl get secret hello-world-default-user -o jsonpath='{.data.password}' | base64 --decode)"

  echo "$username:$password" | pbcopy | echo "The 'username:password' are in your clipboard:
  $username:$password"

  kubectl port-forward "service/$1" 15672 &

  pid=$!

  sleep 1

  open "http://$username:$password@localhost:15672"

  # Trap the EXIT signal and stop the process with the specified PID when the script is terminated
  trap "kill $pid" EXIT

  # Wait for the background process to finish
  wait $pid
fi
