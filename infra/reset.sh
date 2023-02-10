#!/bin/zsh

clusterId=$1
domain=$2

kubectl delete rabbitmqcluster "$clusterId"

