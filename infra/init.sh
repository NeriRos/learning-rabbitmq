#!/bin/zsh

function addDomain() {
  regex='^([a-zA-Z0-9][a-zA-Z0-9-]{0,61}[a-zA-Z0-9]\.)+[a-zA-Z]{2,}$'
  domain="$1"
  if [[ "$domain" =~ $regex ]]; then
    if ! grep -q "$domain" "/etc/hosts"; then
      echo "Adding $domain to hosts file"
      echo "127.0.0.1 $domain" >>/etc/hosts
    else
      echo "Domain $domain already exists in hosts file"
    fi
  else
    echo "First argument has to be a valid domain"
  fi
}

function installHelm() {
  if command -v helm; then
    echo "Helm is already installed"
  else
    echo "Installing Helm"
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm ./get_helm.sh
  fi
}

function installIngressNginx() {
  if kubectl get namespaces | grep ingress-nginx -q; then
    echo "Ingress Nginx is already installed"
  else
    echo "Installing Ingress Nginx"
    helm upgrade --install ingress-nginx ingress-nginx \
      --repo https://kubernetes.github.io/ingress-nginx \
      --namespace ingress-nginx --create-namespace
  fi
}

function installKrew() {
  if kubectl krew | grep -q error; then
    echo "Installing Krew"
    (
      set -x
      cd "$(mktemp -d)" &&
        OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
        KREW="krew-${OS}_${ARCH}" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
        tar zxvf "${KREW}.tar.gz" &&
        ./"${KREW}" install krew
    )

    echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >>~/.zshrc
  else
    echo "Krew is already installed"
  fi
}

function installRabbitMQCommandLine() {
  if kubectl rabbitmq | grep -q error; then
    echo "Installing RabbitMQ Command Line"
    kubectl krew install rabbitmq
  else
    echo "RabbitMQ Command Line is already installed"
  fi
}

function installClusterOperator() {
  if kubectl get all -n rabbitmq-system | grep rabbitmq-cluster-operator -q; then
    echo "RabbitMQ Cluster Operator is already installed"
  else
    echo "Installing RabbitMQ Cluster Operator"
    kubectl rabbitmq install-cluster-operator
  fi
}

if [ $# -eq 0 ]; then
  echo "choose install or init"
  exit
fi

if [ "$1" = "install" ]; then
  installHelm
  installIngressNginx
  installKrew
  installRabbitMQCommandLine
  installClusterOperator
fi

if [ "$1" = "init" ]; then
  if [ $# -eq 1 ]; then
    echo "Add a domain name for local testing"
  else
    addDomain "$2"
  fi
fi
