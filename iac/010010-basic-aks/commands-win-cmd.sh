
cd ../..

# Run the following commands in Windows CMD only. 

# cd into the directory.
cd ./iac/010010-basic-aks

# First setup the required environment vars.
# If you are using windows cmd
set AKS_RESOURCE_GROUP=aks-prod
set AKS_REGION=centralus

echo %AKS_RESOURCE_GROUP%
echo %AKS_REGION%

az group create --location %AKS_REGION% --name %AKS_RESOURCE_GROUP%

az group list

# Create Azure Virtual Network and subnets
# Create Two subnets one for regular AKS Cluster and second one for Azure Virtual Nodes 
# Subnet-1: aks-prod-default
# Subnet-2: aks-prod-virtual-nodes

# Setup the below env vars

# Edit export statements to make any changes required as per your environment
# Execute below export statements 
set AKS_VNET=aks-vnet
set AKS_VNET_ADDRESS_PREFIX=10.0.0.0/8
set AKS_VNET_SUBNET_DEFAULT=aks-subnet-default
set AKS_VNET_SUBNET_DEFAULT_PREFIX=10.240.0.0/16
set AKS_VNET_SUBNET_VIRTUALNODES=aks-subnet-virtual-nodes
set AKS_VNET_SUBNET_VIRTUALNODES_PREFIX=10.241.0.0/16

# Now verify
echo %AKS_VNET%
echo %AKS_VNET_ADDRESS_PREFIX%
echo %AKS_VNET_SUBNET_DEFAULT%
echo %AKS_VNET_SUBNET_DEFAULT_PREFIX%
echo %AKS_VNET_SUBNET_VIRTUALNODES%
echo %AKS_VNET_SUBNET_VIRTUALNODES_PREFIX%

# Create Virtual Network & default Subnet
az network vnet create -g %AKS_RESOURCE_GROUP% ^
                       -n %AKS_VNET% ^
                       --address-prefix %AKS_VNET_ADDRESS_PREFIX% ^
                       --subnet-name %AKS_VNET_SUBNET_DEFAULT% ^
                       --subnet-prefix %AKS_VNET_SUBNET_DEFAULT_PREFIX%

# Verify. Wait for a couple of minutes, then verify
az network vnet list

# Create Virtual Nodes Subnet in Virtual Network
az network vnet subnet create ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --vnet-name %AKS_VNET% ^
    --name %AKS_VNET_SUBNET_VIRTUALNODES% ^
    --address-prefixes %AKS_VNET_SUBNET_VIRTUALNODES_PREFIX%

# Verify, You should see two subnets now. Again wait for a minute
az network vnet list

# Display the Aks Vnet Subnet Defualt Id
az network vnet subnet show ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --vnet-name %AKS_VNET% ^
    --name %AKS_VNET_SUBNET_DEFAULT% ^
    --query id ^
    -o tsv

# Assign the Aks Vnet Subnet Defualt Id to a variable
@FOR /f "delims=" %i in ('az network vnet subnet show ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --vnet-name %AKS_VNET% ^
    --name %AKS_VNET_SUBNET_DEFAULT% ^
    --query id ^
    -o tsv') DO set AKS_VNET_SUBNET_DEFAULT_ID=%i

# Verify
echo %AKS_VNET_SUBNET_DEFAULT_ID%

set AKS_AD_AKSADMIN_GROUP_NAME=aksadmins

echo %AKS_AD_AKSADMIN_GROUP_NAME%

# Create Azure AD Group & Admin User
az ad group create --display-name aksadmins --mail-nickname %AKS_AD_AKSADMIN_GROUP_NAME% --query objectId -o tsv
az ad group show --group %AKS_AD_AKSADMIN_GROUP_NAME% --query id -o tsv
az ad group list

# Just in case if you want to delete use the following
# az ad group delete --group %AKS_AD_AKSADMIN_GROUP_NAME%

az ad group list

# Assign the id to a variable to use later
@FOR /f "delims=" %i in ('az ad group show --group %AKS_AD_AKSADMIN_GROUP_NAME% --query id -o tsv') DO set AKS_AD_AKSADMIN_GROUP_ID=%i

echo %AKS_AD_AKSADMIN_GROUP_ID%

# If you want to use just one single command, you can use the following as well.
@FOR /f "delims=" %i in ('az ad group create ^ 
    --display-name %AKS_AD_AKSADMIN_GROUP_NAME% ^ 
    --mail-nickname %AKS_AD_AKSADMIN_GROUP_NAME% ^
    --query id -o tsv') DO set AKS_AD_AKSADMIN_GROUP_ID=%i

echo %AKS_AD_AKSADMIN_GROUP_ID%

# You can also verify in the portal as well by going to Azure Active Directory, and then groups.

az ad user list

@FOR /f "delims=" %i in ('az ad user create ^
  --display-name "AKS Admin1" ^
  --user-principal-name aksadmin1@vivek7dm1outlook.onmicrosoft.com ^
  --password @AKSDemo123 ^
  --query id -o tsv') DO set AKS_AD_AKSADMIN1_USER_OBJECT_ID=%i

echo %AKS_AD_AKSADMIN1_USER_OBJECT_ID%

# If you wnat to delete. Get the id first
# az ad user delete --id &AKS_AD_AKSADMIN1_USER_OBJECT_ID&

az ad user list

echo %AKS_AD_AKSADMIN1_USER_OBJECT_ID%

# Associate aksadmin User to aksadmins Group

# First get a list of the members in the group
az ad group member list --group %AKS_AD_AKSADMIN_GROUP_NAME%

# Now add
az ad group member add --group %AKS_AD_AKSADMIN_GROUP_NAME% --member-id %AKS_AD_AKSADMIN1_USER_OBJECT_ID%

# Verify
az ad group member list --group %AKS_AD_AKSADMIN_GROUP_NAME%

# Verify the same in the portal as well. 

# Ssh key creation
# First create a directory
mkdir %homepath%\.ssh\aks-prod-sshkeys

# The following command should be executed in the git bash not in powershell nor in cmd

# Create SSH Key(user git bash)
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f ~/.ssh/aks-prod-sshkeys/aksprodsshkey \
    -N mypassphrase

# List Files, using git bash
# ls -lrt $HOME/.ssh/aks-prod-sshkeys

# this using cmd
dir %homepath%\.ssh\aks-prod-sshkeys\

# Set SSH KEY Path
# AKS_SSH_KEY_LOCATION=$HOME/.ssh/aks-prod-sshkeys/aksprodsshkey.pub
# echo $AKS_SSH_KEY_LOCATION

# If you are using windows cmd
set AKS_SSH_KEY_LOCATION=%homepath%\.ssh\aks-prod-sshkeys\aksprodsshkey.pub
echo %AKS_SSH_KEY_LOCATION%

az monitor log-analytics workspace list

# Create the log analytics workspace, then get the id of that created resource, and finally assign that id to a variable.
@FOR /f "delims=" %i in ('az monitor log-analytics workspace create ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --workspace-name aksprod-loganalytics-workspace1 ^
    --query id ^
    -o tsv') DO set AKS_MONITORING_LOG_ANALYTICS_WORKSPACE_ID=%i

echo %AKS_MONITORING_LOG_ANALYTICS_WORKSPACE_ID%

# Wait for some time
az monitor log-analytics workspace list

# Incase you want to delete.
# az monitor log-analytics workspace delete ^
#     --resource-group %AKS_RESOURCE_GROUP% ^
#     --workspace-name aksprod-loganalytics-workspace1 ^
#     --yes

# Incase you want to delete. The follwoing command will ask for confirmation(there is no --yes flag)
#az monitor log-analytics workspace delete ^
#    --resource-group %AKS_RESOURCE_GROUP% ^
#    --workspace-name aksprod-loganalytics-workspace1 ^
        
# List Kubernetes Versions available as on today
az aks get-versions --location %AKS_REGION% -o table

# Get Azure Active Directory (AAD) Tenant ID
# Thr following would not work.
# set AZURE_DEFAULT_AD_TENANTID=$(az account show --query tenantId --output tsv)

@FOR /f "delims=" %i in ('az account show --query tenantId --output tsv') DO set AZURE_DEFAULT_AD_TENANTID=%i

echo %AZURE_DEFAULT_AD_TENANTID%
or
Go to Services -> Azure Active Directory -> Properties -> Tenant ID

# Set Windows Server/Node Username & Password
set AKS_WINDOWS_NODE_USERNAME=azureuser
set AKS_WINDOWS_NODE_PASSWORD="P@ssw0rd123456"
echo %AKS_WINDOWS_NODE_USERNAME%, %AKS_WINDOWS_NODE_PASSWORD%

# Set Cluster Name
set AKS_CLUSTER_NAME=aksprod1
echo %AKS_CLUSTER_NAME%

az aks list

# Now hold your breaths for the final count down.
az aks create --resource-group %AKS_RESOURCE_GROUP% ^
              --name %AKS_CLUSTER_NAME% ^
              --enable-managed-identity ^
              --ssh-key-value  %AKS_SSH_KEY_LOCATION% ^
              --admin-username aksnodeadmin ^
              --node-count 1 ^
              --enable-cluster-autoscaler ^
              --min-count 1 ^
              --max-count 100 ^
              --network-plugin azure ^
              --service-cidr 10.0.0.0/16 ^
              --dns-service-ip 10.0.0.10 ^
              --docker-bridge-address 172.17.0.1/16 ^
              --vnet-subnet-id %AKS_VNET_SUBNET_DEFAULT_ID% ^
              --enable-aad ^
              --aad-admin-group-object-ids %AKS_AD_AKSADMIN_GROUP_ID%^
              --aad-tenant-id %AZURE_DEFAULT_AD_TENANTID% ^
              --windows-admin-password %AKS_WINDOWS_NODE_PASSWORD% ^
              --windows-admin-username %AKS_WINDOWS_NODE_USERNAME% ^
              --node-osdisk-size 30 ^
              --node-vm-size Standard_DS2_v2 ^
              --nodepool-labels nodepool-type=system nodepoolos=linux app=system-apps ^
              --nodepool-name systempool ^
              --nodepool-tags nodepool-type=system nodepoolos=linux app=system-apps ^
              --enable-addons monitoring ^
              --workspace-resource-id %AKS_MONITORING_LOG_ANALYTICS_WORKSPACE_ID% ^
              --enable-ahub ^
              --zones 3

# Get the name of newly created Resource Group MC_aks-prod_aksprod1_centralus
# Get the identity list, you should now see 3. You can see the image as well.
# Get the resource group name, MC_aks-prod_aksprod1_centralus
az identity list --resource-group MC_aks-prod_aksprod1_centralus

az aks show --resource-group %AKS_RESOURCE_GROUP% --name %AKS_CLUSTER_NAME%

az aks show --resource-group %AKS_RESOURCE_GROUP% --name %AKS_CLUSTER_NAME% --query id

az aks show --resource-group %AKS_RESOURCE_GROUP% --name %AKS_CLUSTER_NAME% --query servicePrincipalProfile

@FOR /f "delims=" %i in ('az aks show --resource-group %AKS_RESOURCE_GROUP% ^
              --name %AKS_CLUSTER_NAME% ^
              --query id --output tsv') DO set AKS_ID=%i

echo %AKS_ID%

az aks get-credentials --resource-group %AKS_RESOURCE_GROUP% --name %AKS_CLUSTER_NAME% 

# If you want to logout or unset, use the following.
# kubectl config unset current-context

kubectl get nodes

# When asked, use the following creds
# --user-principal-name aksadmin1@vivek7dm1outlook.onmicrosoft.com ^
# --password @AKSDemo123

kubectl cluster-info

az aks nodepool list

# List Node Pools
az aks nodepool list --cluster-name %AKS_CLUSTER_NAME% --resource-group %AKS_RESOURCE_GROUP% -o table

# List which pods are running in system nodepool from kube-system namespace
kubectl get pod -o=custom-columns=NODE-NAME:.spec.nodeName,POD-NAME:.metadata.name -n kube-system

# A successful cluster creation using managed identities contains this service principal profile information:
az aks show --resource-group %AKS_RESOURCE_GROUP% --name %AKS_CLUSTER_NAME% --query servicePrincipalProfile

# If the aks cluster is in a different resource group than vnet, then you have to do step [11 and 12 of this page](https://github.com/stacksimplify/azure-aks-kubernetes-masterclass/tree/master/23-AKS-Production-Grade-Cluster-Design-using-az-aks-cli/23-01-Create-AKSCluster-with-az-aks-cli).
# Not clear, need to find out.

# Enable Virtual Nodes on our AKS Cluster
# Enable Virtual Nodes Add-On on our AKS Cluster

# Verify Environment Variables
echo %AKS_CLUSTER_NAME%, %AKS_VNET_SUBNET_VIRTUALNODES%

# Enable Virtual Nodes on AKS Cluster
az aks enable-addons ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --name %AKS_CLUSTER_NAME% ^
    --addons virtual-node ^
    --subnet-name %AKS_VNET_SUBNET_VIRTUALNODES%

kubectl get nodes

# Get the name of newly created Resource Group MC_aks-prod_aksprod1_centralus
# Get the identity list, you should now see 3. You can see the image as well.
# Get the resource group name, MC_aks-prod_aksprod1_centralus
az identity list --resource-group MC_aks-prod_aksprod1_centralus

# Get pods
kubectl get pods -n kube-system

# If you want to delete a pod
kubectl delete pod aci-connector-linux-57796b4bf9-t259r -n kube-system

# Observe the output. You will see the aci-connector-linux-686f8748cc-7fld5 pod is not able to start.
# So look at the logs. Ensure you have the connect pod name below
kubectl logs -f aci-connector-linux-57796b4bf9-t259r -n kube-system


kubectl delete pod aci-connector-linux-57796b4bf9-t259r -n kube-system

# Stoped from 163 Step-09_ Create Virtual Nodes and Fix ACI Connector Issues related to Access.mp4

# List Nodes, there should be two now.
kubectl get nodes   

# When its time to delete, you can run the following comands.
az group delete --name %AKS_RESOURCE_GROUP% --yes

az group delete --name NetworkWatcherRG 

az ad group delete --group %AKS_AD_AKSADMIN_GROUP_NAME%

az ad user delete --id %AKS_AD_AKSADMIN1_USER_OBJECT_ID%

az ad user list

az ad group list

az aks list

az group list
