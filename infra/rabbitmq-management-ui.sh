#!/bin/zsh

if [ $# -eq 0 ]; then
    >&2 echo "RabbitMQ Cluster name is required"
    exit 1
fi

echo "Getting RabbitMQ management username and password for cluster: $1"

username="$(kubectl get secret hello-world-default-user -o jsonpath='{.data.username}' | base64 --decode)"
echo "username: $username"

password="$(kubectl get secret hello-world-default-user -o jsonpath='{.data.password}' | base64 --decode)"
echo "password: $password"

echo "$username:$password" | pbcopy | echo "The 'username:password' are in your clipboard"

open http://localhost:15672

kubectl port-forward "service/$1" 15672

