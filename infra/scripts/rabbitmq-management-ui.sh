#!/bin/zsh

if [ $# -eq 0 ]; then
  echo >&2 "RabbitMQ Cluster name is required"
  exit 1
fi

clusterId=$1

echo "Getting RabbitMQ management username and password for cluster: $clusterId"

username="$(kubectl get secret "$clusterId-default-user" -o jsonpath='{.data.username}' | base64 --decode)"
password="$(kubectl get secret "$clusterId-default-user" -o jsonpath='{.data.password}' | base64 --decode)"

echo "$username:$password" | pbcopy
echo "The 'username:password' are in your clipboard: $username:$password"

if ! (kubectl scripts version | grep -q error); then
  kubectl scripts manage "$clusterId"
else
  kubectl port-forward "service/$clusterId" 15672 &

  pid=$!

  sleep 1

  open "http://$username:$password@localhost:15672"

  # Trap the EXIT signal and stop the process with the specified PID when the script is terminated
  trap "kill $pid" EXIT

  # Wait for the background process to finish
  wait $pid
fi
