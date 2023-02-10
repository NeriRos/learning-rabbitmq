#!/bin/zsh

if [ $# -eq 0 ]; then
  echo >&2 "RabbitMQ Cluster name is required"
  exit 1
fi

echo "Logging cluster: $1"

kubectl logs "$1-server-0" -f
