#!/bin/zsh

if [ $# -eq 0 ]; then
  echo >&2 "RabbitMQ Cluster name is required"
  exit 1
fi

clusterId=$1

username="$(kubectl get secret "$clusterId-default-user" -o jsonpath='{.data.username}' | base64 --decode)"
password="$(kubectl get secret "$clusterId-default-user" -o jsonpath='{.data.password}' | base64 --decode)"

envPath="../../backend/.env"

echo "Replacing $(cat $envPath | grep RABBITMQ_USERNAME) with: RABBITMQ_USERNAME=$username"
sed -i .bu "s/RABBITMQ_USERNAME=.*/RABBITMQ_USERNAME=$username/g" $envPath

echo "Replacing $(cat $envPath | grep RABBITMQ_PASSWORD) with: RABBITMQ_PASSWORD=$password"
sed -i .bu "s/RABBITMQ_PASSWORD=.*/RABBITMQ_PASSWORD=$password/g" $envPath
