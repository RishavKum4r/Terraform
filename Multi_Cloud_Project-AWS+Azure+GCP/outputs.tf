output "aws_internet_public_ip" {
  value       = aws_instance.BITS-Project-AWS-Instance.public_ip
  description = "Public IP address of the AWS EC2 Instance."
}

output "aws_instance_private_ip" {
  value       = aws_instance.BITS-Project-AWS-Instance.private_ip
  description = "Private IP address of the AWS EC2 Instance."
}

output "azure_public_ip_address" {
  value       = azurerm_public_ip.BITS-Project-Azure-PIP.ip_address
  description = "Public IP address of the Azure virtual machine."
}

output "azure_private_ip_address" {
  value       = azurerm_network_interface.BITS-Project-Azure-NI.private_ip_address
  description = "Private IP address of the Azure virtual machine."
}

output "gcp_instance_public_ip" {
  value       = google_compute_instance.BITS-Project-GCP-VM.network_interface.0.access_config.0.nat_ip
  description = "Public IP address of the GCP Compute engine Instance."
}

output "gcp_instance_private_ip" {
  value       = google_compute_instance.BITS-Project-GCP-VM.network_interface.0.network_ip
  description = "Private IP address of the GCP Compute engine Instance."
}