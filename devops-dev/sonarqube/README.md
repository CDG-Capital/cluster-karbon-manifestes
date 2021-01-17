# Getting value-gitlab.yaml

helm inspect values oteemocharts/sonarqube > values-sonarqube.yaml

# Create Namespace git-system:

kubectl --kubeconfig /home/centos/.kube/config-devops-dev create ns sonar-system

# Installing Gitlab by helm chart

helm repo add oteemocharts https://oteemo.github.io/charts

helm repo update

helm --kubeconfig /home/centos/.kube/config-devops-dev -n sonar-system install sonarqube -f values-sonarqube.yaml oteemocharts/sonarqube

