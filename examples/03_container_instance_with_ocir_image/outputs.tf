output "ocir_repository_id" {
  value = module.ocir.repository_id
}

output "ocir_image_prefix" {
  value = module.ocir.image_prefix
}

output "deployed_image" {
  value = local.hello_world_image
}

output "container_instance_id" {
  value = module.container_instance.container_instance_id
}

output "container_instance_state" {
  value = module.container_instance.container_instance_state
}

output "container_private_ip" {
  value = module.container_instance.primary_private_ip
}

output "load_balancer_public_ips" {
  value = module.load_balancer.load_balancer_public_ips
}

output "reserved_public_ip" {
  value = module.public_ip.ip_address
}

output "backend_set_name" {
  value = module.load_balancer.backend_set_name
}

output "vcn_id" {
  value = module.vcn.vcn_id
}
