# Getting value-gitlab.yaml

helm inspect values gitlab/gitlab > values-gitlab.yaml

# Create Namespace git-system:

kubectl --kubeconfig /home/centos/.kube/config-devops-dev create ns git-system

# Installing Gitlab by helm chart

helm repo add gitlab https://charts.gitlab.io

helm repo update

helm --kubeconfig /home/centos/.kube/config-devops-dev -n git-system install gitlab -f values-gitlab.yaml gitlab/gitlab

# Editing ingress and deletting nginx-class

kubectl --kubeconfig /home/centos/.kube/config-devops-dev -n git-system edit ing gitlab-webservice-default

# Editing PVC and increase the size of storage from 50Gi to 100Gi

kubectl --kubeconfig /home/centos/.kube/config-devops-dev -n git-system edit pvc repo-data-gitlab-gitaly-0
