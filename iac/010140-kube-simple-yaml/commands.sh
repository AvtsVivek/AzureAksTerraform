cd ../..

# cd into the directory.
cd ./iac/010140-kube-simple-yaml

terraform fmt

terraform init

terraform validate

terraform plan -out main.tfplan

# terraform show main.tfplan

terraform apply main.tfplan 

terraform state list

terraform state show 

terraform show terraform.tfstate

# Get the resource group name and AKS_CLUSTER_NAME 
# Default admin

kubectl cluster-info

az aks get-credentials --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster --overwrite-existing

kubectl cluster-info

# If you want to logout or unset, use the following.
# kubectl config unset current-context

kubectl get nodes

kubectl get nodes -o wide

az aks show --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster

kubectl cluster-info

az aks nodepool list

az aks nodepool list --resource-group aks-tf-trial1-rg-dev --cluster-name aks-tf-trial1-rg-dev-aks-cluster -o table

kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name -n kube-system

# The following should show msi(managed system identity)
az aks show --resource-group aks-tf-trial1-rg-dev --name aks-tf-trial1-rg-dev-aks-cluster --query servicePrincipalProfile

# Why is the following giving empity array? Not sure. Need to find out(some times).
# httpapplicationrouting-terraform-aks-dev-aks-cluster
# omsagent-terraform-aks-dev-aks-cluster
# azurepolicy-terraform-aks-dev-aks-cluster
# terraform-aks-dev-aks-cluster-agentpool
az identity list --resource-group aks-tf-trial1-rg-dev
az identity list --resource-group aks-tf-trial1-rg-dev-nrg

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/04-Kubernetes-Fundamentals-with-YAML/04-02-PODs-with-YAML

# Get pods
kubectl get pods -n kube-system

kubectl get pods -n default

kubectl get all -n default

# https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/04-Kubernetes-Fundamentals-with-YAML/04-03-ReplicaSets-with-YAML

###################################################################################

kubectl apply -f .\kube-manifests\1-pod\

# Or individually 
kubectl apply -f .\kube-manifests\1-pod\02-pod-definition.yml
kubectl apply -f .\kube-manifests\1-pod\03-pod-lb-service.yml

# List Replicasets
kubectl get po
kubectl get svc

kubectl get svc -o json

# Install Jq(https://stedolan.github.io/jq/, download jq-win64.exe, rename that to jq.exe. Then place it in some folder, add that folder to the path env var)
# The open a new command prompt and then exectte the following. It should give the external ip
kubectl get svc myapp-pod-loadbalancer-service -o json | jq '.status.loadBalancer.ingress[].ip'

kubectl delete -f .\kube-manifests\1-pod-service\

###################################################################################

kubectl apply -f .\kube-manifests\2-replica-set\

# Or individually 
kubectl apply -f .\kube-manifests\2-replica-set\02-replicaset-definition.yml
kubectl apply -f .\kube-manifests\2-replica-set\03-replicaset-lb-service.yml

kubectl get po
kubectl get svc
kubectl get rs

# Install Jq(https://stedolan.github.io/jq/, download jq-win64.exe, rename that to jq.exe. Then place it in some folder, add that folder to the path env var)
# The open a new command prompt and then exectte the following. It should give the external ip
kubectl get svc replicaset-loadbalancer-service -o json | jq '.status.loadBalancer.ingress[].ip'

# Now browse to that External IP

kubectl delete -f .\kube-manifests\2-replica-set\

###################################################################################

kubectl apply -f .\kube-manifests\3-deployment\

# Or individually 
kubectl apply -f .\kube-manifests\3-deployment\02-deployment-definition.yml
kubectl apply -f .\kube-manifests\3-deployment\03-deployment-lb-service.yml

kubectl get po
kubectl get deploy
kubectl get svc
kubectl get rs

# Install Jq(https://stedolan.github.io/jq/, download jq-win64.exe, rename that to jq.exe. Then place it in some folder, add that folder to the path env var)
# The open a new command prompt and then exectte the following. It should give the external ip
kubectl get svc deployment-loadbalancer-service -o json | jq '.status.loadBalancer.ingress[].ip'

# Now browse to that External IP

kubectl delete -f .\kube-manifests\3-deployment\

###################################################################################

kubectl apply -f .\kube-manifests\4-service\

kubectl apply -f .\kube-manifests\4-service\2-backend-deployment.yml
kubectl apply -f .\kube-manifests\4-service\3-backend-clusterip-service.yml
kubectl apply -f .\kube-manifests\4-service\4-frontend-deployment.yml
kubectl apply -f .\kube-manifests\4-service\5-frontend-LoadBalancer-service.yml

kubectl get po
kubectl get deploy
kubectl get svc
kubectl get rs

# Install Jq(https://stedolan.github.io/jq/, download jq-win64.exe, rename that to jq.exe. Then place it in some folder, add that folder to the path env var)
# The open a new command prompt and then exectte the following. It should give the external ip
kubectl get svc frontend-nginxapp-loadbalancer-service -o json | jq '.status.loadBalancer.ingress[].ip'

# Now browse to that External IP
http://<EXTERNAL-IP>
http://<EXTERNAL-IP>/hello

kubectl delete -f .\kube-manifests\4-service\

###################################################################################

kubectl get deploy --namespace default

kubectl create deployment my-backend-rest-app --image=stacksimplify/kube-helloworld:1.0.0 

kubectl get deploy

kubectl get rs

kubectl get pod

# Just verify, get the pod name.
kubectl logs -f my-backend-rest-app-54fb6575d9-c6p64

# Create ClusterIp Service for Backend Rest App
# Note We don't need to specify "--type=ClusterIp" because default setting is to create ClusterIp Service.
kubectl expose deployment my-backend-rest-app --port=8080 --target-port=8080 --name=my-backend-service
kubectl get svc

kubectl get svc -o wide

kubectl get svc -o json

# Install Jq(https://stedolan.github.io/jq/, download jq-win64.exe, rename that to jq.exe. Then place it in some folder, add that folder to the path env var)
# The open a new command prompt and then exectte the following. It should give the type of the service as ClusterIP
kubectl get svc my-backend-service -o json | jq '.spec.type'

# Now the front end part.

# Create Deployment for Frontend Nginx Proxy
# kubectl create deployment my-frontend-nginx-app --image=stacksimplify/kube-frontend-nginx:1.0.0 
kubectl create deployment my-frontend-nginx-app --image=avts/nginxvivekproxy:v1

kubectl get deploy

kubectl delete deploy my-frontend-nginx-app

kubectl get pod

# Create ClusterIp Service for Frontend Nginx Proxy
kubectl expose deployment my-frontend-nginx-app  --type=LoadBalancer --port=80 --target-port=80 --name=my-frontend-service
kubectl get svc

kubectl get pod

kubectl logs -f my-backend-rest-app-54fb6575d9-szwg9

kubectl get svc my-frontend-service -o json

# Capture External IP of the loadbalancer service.

# Install Jq(https://stedolan.github.io/jq/, download jq-win64.exe, rename that to jq.exe. Then place it in some folder, add that folder to the path env var)
# The open a new command prompt and then exectte the following. It should give the Extenal ip of the loadbalancer service
kubectl get svc my-frontend-service -o json | jq '.status.loadBalancer.ingress[].ip'

# Now browse to the ip address/hello.
http://<EXTERNAL-IP>/hello

# Scale backend with 10 replicas
kubectl scale --replicas=10 deployment/my-backend-rest-app

# Test again to view the backend service Load Balancing
http://<EXTERNAL-IP>/hello

##################################################################################################### 

# Clean up

# Delete Deployment
kubectl delete deployment my-backend-rest-app
kubectl delete deployment my-frontend-nginx-app

# Delete Service
kubectl delete svc my-backend-service

kubectl delete svc my-frontend-service

# Get all Objects from Kubernetes default namespace
kubectl get all

##############################################################################

terraform plan -destroy -out main.destroy.tfplan

# terraform show main.destroy.tfplan

terraform apply main.destroy.tfplan

Remove-Item -Recurse -Force .terraform/modules

Remove-Item -Recurse -Force .terraform

Remove-Item terraform.tfstate

Remove-Item terraform.tfstate.backup

Remove-Item main.tfplan

Remove-Item main.destroy.tfplan

Remove-Item .terraform.lock.hcl
