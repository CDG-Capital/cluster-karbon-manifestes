# merci de proceder par ordre lors du lancement de ECK à savoir:
1 operator --> elasticsearch --> kibana --> filebeat --> ingress

# pour avoir le mot de passe d'user elastic: (valable pour elasticsearch et kibana aussi)
kubectl -n monitoring get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'
