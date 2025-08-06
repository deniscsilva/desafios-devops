#/bin/bash
 echo "Deletando objetos..."
 kubectl delete -f k8s/ingress.yaml
 kubectl delete -f k8s/service.yaml
 kubectl delete -f k8s/deployment.yaml
 kubectl delete -f k8s/configmap.yaml
 echo "Objetos deletados."
