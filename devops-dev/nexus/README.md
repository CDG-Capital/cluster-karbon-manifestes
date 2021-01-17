# Getting value-gitlab.yaml

helm inspect values oteemocharts/sonatype-nexus > values-nexus.yaml

# Create Namespace git-system:

kubectl --kubeconfig /home/centos/.kube/config-devops-dev create ns nexus-system

# Installing Gitlab by helm chart

helm repo add oteemocharts https://oteemo.github.io/charts

helm repo update

helm --kubeconfig /home/centos/.kube/config-devops-dev -n nexus-system install nexus-sonatype -f values-nexus.yaml oteemocharts/sonatype-nexus

