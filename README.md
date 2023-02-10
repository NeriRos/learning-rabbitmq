# Learning RabbitMQ

## Deployment

- execute `./infra/init.sh install`
- execute `./infra/init.sh init <domain_for_testing>`

## The project

The goal is to experiment with RabbitMQ and Kubernetes.

### What I've done to set up the project

#### Setup

1. Create nodejs project for the backend
2. Create a react app for the front
3. Write a Dockerfile for each
4. Write a kubernetes deployment file for each
5. Write a skaffold file to build dockers and deploy cluster
6. Add RabbitMQ Cluster Operator deployment file
7. Write script to open RabbitMQ management ui
8. Write an Init file to install required prerequisites and define settings
9. Add logging script

#### Development
1. Install RabbitMQ amqp protocol for javascript `amqplib`

### Commands and resources

- [krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/) Installation
- RabbitMQ command line installation `kubectl krew install rabbitmq`
- RabbitMQ amqp library for js `npm install amqplib`
  and [documentation](https://amqp-node.github.io/amqplib/channel_api.html)
- Access RabbitMQ management ui by running `./rabbitmq-management-ui.sh`
