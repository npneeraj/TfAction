output "ec2_instance_id" {
  value       = module.ec2.instance_id
  description = "The ID of the provisioned EC2 instance"
}

output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "The public IP of the provisioned EC2 instance, useful for SSH access"
}

output "ec2_private_ip" {
  value       = module.ec2.private_ip
  description = "The private IP of the provisioned EC2 instance"
}
