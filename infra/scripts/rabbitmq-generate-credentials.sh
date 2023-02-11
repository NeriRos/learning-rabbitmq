#!/bin/zsh

clusterId=$1

if [ -z "$clusterId" ]; then
  echo "RabbitMQ Cluster name is required"
  exit
fi

username="$(kubectl get secret "$clusterId-default-user" -o jsonpath='{.data.username}' | base64 --decode)"
password="$(kubectl get secret "$clusterId-default-user" -o jsonpath='{.data.password}' | base64 --decode)"

printf "RabbitMQ Credentials\nUsername:%s\nPassword:%s\n" "$username" "$password"

if [ -z "$2" ]; then
  echo "Add env file destinations (optional)"
  exit
fi

for envPath in "${@:2}"; do

  if ! test -f "$envPath"; then
    touch "$envPath"
    printf "RABBITMQ_HOST=%s\nRABBITMQ_USERNAME=temp\nRABBITMQ_PASSWORD=temp" "$clusterId" >"$envPath"
  fi

  echo "Setting env for $envPath"

  sed -i .bu "s/RABBITMQ_HOST=.*/RABBITMQ_HOST=$clusterId/g" "$envPath"
  sed -i .bu "s/RABBITMQ_USERNAME=.*/RABBITMQ_USERNAME=$username/g" "$envPath"
  sed -i .bu "s/RABBITMQ_PASSWORD=.*/RABBITMQ_PASSWORD=$password/g" "$envPath"
done
