# Learning RabbitMQ

## Deployment

- Deploy a RabbitMQ Container `docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672
  rabbitmq:3.
  11-management`

## The project

The goal is to experiment with RabbitMQ and Kubernetes.

### What I've done

1. Create nodejs project for the backend
2. Create a React app for the front
3. Wrote a Dockerfile for each
4. Wrote a kubernetes deployment file for each
5. Wrote a Skaffold file to build dockers and deploy cluster.