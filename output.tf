output "ec2_my_vm_public_ip" {
  value       = module.my_ec2.ec2_vm_public_ip
  description = "The public IP address of the EC2 instance"
}
