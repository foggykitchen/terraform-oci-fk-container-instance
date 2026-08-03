output "container_instance_id" {
  value = module.container_instance.container_instance_id
}

output "container_instance_state" {
  value = module.container_instance.container_instance_state
}

output "container_public_ip" {
  value = module.container_instance.primary_public_ip
}

output "container_private_ip" {
  value = module.container_instance.primary_private_ip
}

output "vcn_id" {
  value = module.vcn.vcn_id
}
