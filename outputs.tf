output "container_instance_id" {
  description = "OCI Container Instance OCID."
  value       = oci_container_instances_container_instance.this.id
}

output "container_instance_name" {
  description = "OCI Container Instance display name."
  value       = oci_container_instances_container_instance.this.display_name
}

output "container_instance_state" {
  description = "OCI Container Instance lifecycle state."
  value       = oci_container_instances_container_instance.this.state
}

output "container_count" {
  description = "Number of containers deployed on the container instance."
  value       = oci_container_instances_container_instance.this.container_count
}

output "containers" {
  description = "Container summaries returned by OCI."
  value       = oci_container_instances_container_instance.this.containers
}

output "vnic_ids" {
  description = "VNIC OCIDs attached to the container instance."
  value       = [for vnic in oci_container_instances_container_instance.this.vnics : vnic.vnic_id]
}

output "primary_vnic_id" {
  description = "Primary VNIC OCID."
  value       = try(oci_container_instances_container_instance.this.vnics[0].vnic_id, null)
}

output "primary_private_ip" {
  description = "Primary VNIC private IP address."
  value       = try(data.oci_core_vnic.primary[0].private_ip_address, null)
}

output "primary_public_ip" {
  description = "Primary VNIC public IP address, when assigned."
  value       = try(data.oci_core_vnic.primary[0].public_ip_address, null)
}

output "volume_count" {
  description = "Number of volumes attached to the container instance."
  value       = oci_container_instances_container_instance.this.volume_count
}
