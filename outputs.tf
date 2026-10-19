output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "bastion_host_vm_public_ip" {
  description = "Public IP of the Bastion Host Linux VM (SSH port 22)"
  value       = azurerm_public_ip.bastion_host.ip_address
}

output "bastion_host_ssh_command" {
  value = "ssh ${var.admin_username}@${azurerm_public_ip.bastion_host.ip_address}"
}

output "bastion_vm1_private_ip" {
  value = azurerm_network_interface.bastion_vm1.private_ip_address
}

output "web_vm1_private_ip" {
  description = "SSH to this from the Bastion VM or via Azure Bastion Service"
  value       = azurerm_network_interface.web_vm1.private_ip_address
}

output "azure_bastion_service_public_ip" {
  description = "Public IP of the Azure Bastion Service (browser access over SSL 443 via Azure Portal)"
  value       = azurerm_public_ip.bastion_service.ip_address
}

output "web_vm1_ssh_via_bastion_host" {
  description = "Reach Web VM-1 through the Bastion Host VM in one command (ProxyJump)"
  value       = "ssh -J ${var.admin_username}@${azurerm_public_ip.bastion_host.ip_address} ${var.admin_username}@${azurerm_network_interface.web_vm1.private_ip_address}"
}
