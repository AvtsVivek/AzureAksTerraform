
cd ../..

# cd into the directory.
cd ./iac/210010-basic-aks-cli

# First setup the required environment vars.

# Powershell
$env:AZURE_RESOURCE_GROUP = 'aks-prod'
# The value should be in quotes. The following will not work.
# $env:AKS_REGION=centralus
# The following should work.
$env:AKS_REGION = 'centralus'

# Verify
$env:AZURE_RESOURCE_GROUP 
$env:AKS_REGION

# If you are using Git bash
export AZURE_RESOURCE_GROUP='aks-prod'
export AKS_REGION='centralus'

# Verify for bash shell
echo $AZURE_RESOURCE_GROUP $AKS_REGION

# The followoing are not working in gitbash or powershell 
# Issue raised on SO
# https://stackoverflow.com/q/73467139/1977871

az group create --location $AKS_REGION --name $AKS_RESOURCE_GROUP

az group create --location ${AKS_REGION} --name ${AKS_RESOURCE_GROUP}

az group create --location $env:AKS_REGION --name $env:AKS_RESOURCE_GROUP

# If you are using windows cmd
set AKS_RESOURCE_GROUP=aks-prod
set AKS_REGION=centralus

echo %AKS_RESOURCE_GROUP%
echo %AKS_REGION%

az group create --location %AKS_REGION% --name %AZURE_RESOURCE_GROUP%

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

# Verify
az network vnet list


# Create Virtual Nodes Subnet in Virtual Network
az network vnet subnet create ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --vnet-name %AKS_VNET% ^
    --name %AKS_VNET_SUBNET_VIRTUALNODES% ^
    --address-prefixes %AKS_VNET_SUBNET_VIRTUALNODES_PREFIX%

# Verify, You should see two subnets now.
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

# Create Azure AD Group & Admin User
az ad group create --display-name aksadmins --mail-nickname aksadmins --query objectId -o tsv
az ad group show --group aksadmins --query id -o tsv
az ad group list

# Just in case if you want to delete
az ad group delete --group aksadmins

az ad group list

# Assign the id to a variable to use later
@FOR /f "delims=" %i in ('az ad group show --group aksadmins --query id -o tsv') DO set AKS_AD_AKSADMIN_GROUP_ID=%i

echo %AKS_AD_AKSADMIN_GROUP_ID%

# If you want to use just one single command, you can use the following as well.
@FOR /f "delims=" %i in ('az ad group create ^ 
    --display-name aksadmins ^ 
    --mail-nickname aksadmins ^
    --query id -o tsv') DO set AKS_AD_AKSADMIN_GROUP_ID=%i

echo %AKS_AD_AKSADMIN_GROUP_ID%

# You can also verify in the portal as well by going to Azure Active Directory, and then groups.

az ad user list

@FOR /f "delims=" %i in ('az ad user create ^
  --display-name "AKS Admin1" ^
  --user-principal-name aksadmin1@vivek7dm1outlook.onmicrosoft.com ^
  --password @AKSDemo123 ^
  --query id -o tsv') DO set AKS_AD_AKSADMIN1_USER_OBJECT_ID=%i

# If you wnat to delete. Get the id first
az ad user delete --id 1e40e7ff-3de9-4bef-b859-6fa43f837277

az ad user list

echo %AKS_AD_AKSADMIN1_USER_OBJECT_ID%


# Associate aksadmin User to aksadmins Group

# First get a list of the members in the group
az ad group member list --group aksadmins

# Now add
az ad group member add --group aksadmins --member-id %AKS_AD_AKSADMIN1_USER_OBJECT_ID%

# Verify
az ad group member list --group aksadmins

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
ls -lrt $HOME/.ssh/aks-prod-sshkeys

# Set SSH KEY Path
AKS_SSH_KEY_LOCATION=$HOME/.ssh/aks-prod-sshkeys/aksprodsshkey.pub
echo $AKS_SSH_KEY_LOCATION

# If you are using windows cmd
set AKS_SSH_KEY_LOCATION=%homepath%\.ssh\aks-prod-sshkeys\aksprodsshkey.pub
echo %AKS_SSH_KEY_LOCATION%

az monitor log-analytics workspace list

@FOR /f "delims=" %i in ('az monitor log-analytics workspace create ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --workspace-name aksprod-loganalytics-workspace1 ^
    --query id ^
    -o tsv') DO set AKS_MONITORING_LOG_ANALYTICS_WORKSPACE_ID=%i

echo %AKS_MONITORING_LOG_ANALYTICS_WORKSPACE_ID%

az monitor log-analytics workspace list

# Incase you want to delete.
az monitor log-analytics workspace delete ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --workspace-name aksprod-loganalytics-workspace1 ^
    --yes

# Incase you want to delete. The follwoing command will ask for confirmation(there is no --yes flag)
az monitor log-analytics workspace delete ^
    --resource-group %AKS_RESOURCE_GROUP% ^
    --workspace-name aksprod-loganalytics-workspace1 ^
        
# List Kubernetes Versions available as on today
az aks get-versions --location %AKS_REGION% -o table

# Get Azure Active Directory (AAD) Tenant ID
set AZURE_DEFAULT_AD_TENANTID=$(az account show --query tenantId --output tsv)

@FOR /f "delims=" %i in ('az account show --query tenantId --output tsv') DO set AZURE_DEFAULT_AD_TENANTID=%i

echo %AZURE_DEFAULT_AD_TENANTID%
or
Go to Services -> Azure Active Directory -> Properties -> Tenant ID

# Set Windows Server/Node Username & Password
set AKS_WINDOWS_NODE_USERNAME=azureuser
set AKS_WINDOWS_NODE_PASSWORD="P@ssw0rd123456"
echo %AKS_WINDOWS_NODE_USERNAME%, %AKS_WINDOWS_NODE_PASSWORD%

# Set Cluster Name
set AKS_CLUSTER=aksprod1
echo %AKS_CLUSTER%

az aks list

# Now hold your breaths for the final count down.
az aks create --resource-group %AKS_RESOURCE_GROUP% ^
              --name %AKS_CLUSTER% ^
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

