# Define Input Variables
# 1. Azure Location (CentralUS)
# 2. Azure Resource Group Name 
# 3. Azure AKS Environment Name (Dev, QA, Prod)

# Azure Location
variable "resource_group_location" {
  type        = string
  description = "Azure Region where all these resources will be provisioned"
  default     = "Central India"
}

# Azure Resource Group Name
variable "resource_group_name" {
  type        = string
  description = "This variable defines the Resource Group"
  default     = "aks-tf-trial1-rg"
}

# Environment Name
variable "environment" {
  type        = string
  description = "This variable defines the Environment"
  default     = "dev"
}

# AKS Input Variables

# SSH Public Key for Linux VMs
variable "ssh_public_key" {
  default = "~/.ssh/aks-prod-sshkeys/aksprodsshkey.pub"
  # C:\Users\msi\.ssh\aks-prod-sshkeys
  description = "This variable defines the SSH Public Key for Linux k8s Worker nodes"
}

# Windows Admin Username for k8s worker nodes
variable "windows_admin_username" {
  type        = string
  default     = "azureuser"
  description = "This variable defines the Windows admin username k8s Worker nodes"
}

# Windows Admin Password for k8s worker nodes
variable "windows_admin_password" {
  type        = string
  default     = "P@ssw0rd123456"
  description = "This variable defines the Windows admin password k8s Worker nodes"
}

#################################################################################################


# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type        = string
  default     = "vivek-hr"
}

# 5. Common Tags
variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type        = map(string)
  default = {
    "CLITool" = "Terraform"
    "Tag1"    = "Azure"
  }
}

## service plan name

# variable "storage_account_name" {
#   description = "Storage account for Sql Server db"
#   type        = string
#   default     = "mssqlstorageaccount"
# }

variable "mssql_server_name" {
  description = "Ms Sql server name"
  type        = string
  default     = "ms-sql-server"
}

variable "mssql_database_name" {
  description = "Ms Sql Database Name "
  type        = string
  default     = "ms-sql-db"
}

variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "sap"
}


# Define Local Values in Terraform
locals {
  owners               = var.business_divsion
  environment          = var.environment
  resource_name_prefix = "${var.business_divsion}-${var.environment}"
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}

variable "db_username" {
  description = "Azure MySQL Database Administrator Username"
  type        = string
  sensitive   = true
}
# 8. Azure MySQL DB Password (Variable Type: Sensitive String)
variable "db_password" {
  description = "Azure MySQL Database Administrator Password"
  type        = string
  sensitive   = true
}