#!/bin/zsh

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
fi

if kubectl rabbitmq | grep -q error; then
  echo "Installing RabbitMQ Command Line"
  kubectl krew install rabbitmq
fi

echo "Installing RabbitMQ Cluster Operator"
kubectl rabbitmq install-cluster-operator
