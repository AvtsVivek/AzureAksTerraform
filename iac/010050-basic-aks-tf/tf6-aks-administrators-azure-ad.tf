# Create Azure AD Group in Active Directory for AKS Admins
resource "azuread_group" "aks_administrators" {
  display_name = "${azurerm_resource_group.aks_rg.name}-cluster-admins"
  description  = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.aks_rg.name}-cluster."
}


resource "azuread_user" "aks_user" {
  user_principal_name = "aksadmin1@vivek7dm1outlook.onmicrosoft.com"
  display_name        = "AKS Admin1"
  mail_nickname       = "AksAdmin1"
  password            = "@AKSDemo123"
}

resource "azuread_group_member" "example" {
  group_object_id  = azuread_group.aks_administrators.id
  member_object_id = azuread_user.aks_user.id
}

# # The following command Adds a user the Active Directory and also assigns the added user to a variable.
# @FOR /f "delims=" %i in ('az ad user create ^
#   --display-name "AKS Admin1" ^
#   --user-principal-name aksadmin1@vivek7dm1outlook.onmicrosoft.com ^
#   --password @AKSDemo123 ^
#   --query id -o tsv') DO set AKS_AD_AKSADMIN1_USER_OBJECT_ID=%i

# echo %AKS_AD_AKSADMIN1_USER_OBJECT_ID%

