# Learning RabbitMQ

## Deployment

- Deploy a RabbitMQ Container `docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672
  rabbitmq:3.
  11-management`

## The project

The goal is to experiment with RabbitMQ and Kubernetes.

### What I've done to set up the project

1. Create `nodejs` project for the backend
2. Create a `react` app for the front
3. Write a `Dockerfile` for each
4. Write a `kubernetes` deployment file for each
5. Write a `skaffold` file to build dockers and deploy cluster.
6. Add `RabbitMQ Cluster Operator` to `skaffold`
7. Write script to open RabbitMQ management ui
8. Install RabbitMQ amqp protocol for javascript `amqplib`

### Commands and resources

- [krew](https://krew.sigs.k8s.io/docs/user-guide/setup/install/) Installation
- RabbitMQ command line installation `kubectl krew install rabbitmq`
- RabbitMQ amqp library for js `npm install amqplib`
- Access RabbitMQ management ui by running `./rabbitmq-management-ui.sh`
