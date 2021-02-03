# installation using helm, don't forget to create namespace ingress-nginx

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install -n ingress-nginx ingress-nginx ingress-nginx/ingress-nginx -f values.yml
