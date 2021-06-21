# Site : https://jenkinsci.github.io/kubernetes-operator/docs/installation/

# Configure Custom Resource Definition

kubectl apply -f https://raw.githubusercontent.com/jenkinsci/kubernetes-operator/master/deploy/all-in-one-v1alpha2.yaml


# Deploy Jenkins Operator

# Using YAML’s

kubectl apply -f https://raw.githubusercontent.com/jenkinsci/kubernetes-operator/master/deploy/all-in-one-v1alpha2.yaml


# Watch Jenkins Operator instance being created

kubectl get pods -w


# Using Helm Chart

# Create a namespace for the operator

kubectl create namespace <your-namespace>

# To install, you need only to type these commands:

helm repo add jenkins https://raw.githubusercontent.com/jenkinsci/kubernetes-operator/master/chart

helm repo update

# Getting values.yaml

 helm inspect values jenkins/jenkins-operator > values.yaml 

# Installing helm jenkins

helm install <name> jenkins/jenkins-operator -n <your-namespace>

# Create Configmaps for backup

kdevops -n integration create cm custom-backup-cm --from-file=backup.sh


# Credentials in jenkins are created by adding secrets and jenkins discover them automaticcaly

# more examples here : https://jenkinsci.github.io/kubernetes-credentials-provider-plugin/examples/



