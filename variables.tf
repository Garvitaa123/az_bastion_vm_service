variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "centralindia"
}

variable "prefix" {
  description = "Prefix used for naming all resources"
  type        = string
  default     = "demo"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default = {
    project     = "azure-bastion-demo"
    environment = "dev"
  }
}

# Network
variable "vnet_address_space" {
  type    = list(string)
  default = ["10.1.0.0/16"]
}

variable "web_subnet_cidr" {
  type    = list(string)
  default = ["10.1.1.0/24"]
}

variable "app_subnet_cidr" {
  type    = list(string)
  default = ["10.1.11.0/24"]
}

variable "db_subnet_cidr" {
  type    = list(string)
  default = ["10.1.21.0/24"]
}

variable "bastion_host_subnet_cidr" {
  description = "Subnet for the Bastion Host Linux VM (jump box)"
  type        = list(string)
  default     = ["10.1.100.0/24"]
}

variable "bastion_service_subnet_cidr" {
  description = "Subnet for Azure Bastion Service (must be /26 or larger)"
  type        = list(string)
  default     = ["10.1.101.0/26"]
}

variable "admin_source_address_prefix" {
  description = "Source IP/CIDR allowed to SSH to the Bastion Host VM public IP. Use your own public IP/32 instead of * for security."
  type        = string
  default     = "*"
}

# VM

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_ssh_public_key_path" {
  description = "Path to your SSH PUBLIC key (generate with: ssh-keygen -t rsa -b 4096)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "availability_zone" {
  description = "Availability zone for VMs and their data disks (zones 1 and 3 were not working, so 2 is the default)"
  type        = string
  default     = "2"
}

variable "os_disk_size_gb" {
  type    = number
  default = 30
}