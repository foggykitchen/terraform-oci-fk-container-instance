# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_data "oci_core_vnic" {
    defaults = { "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "compartment_id" = "MOCK_OCID_COMPARTMENT", "defined_tags" = {}, "display_name" = "compatibility", "freeform_tags" = {}, "hostname_label" = "mock-value", "id" = "MOCK_OCID_VNIC", "ipv6addresses" = ["mock-value"], "is_primary" = false, "mac_address" = "mock-value", "nsg_ids" = ["mock-value"], "private_ip_address" = "10.0.0.10", "public_ip_address" = "10.0.0.10", "route_table_id" = "MOCK_OCID_MOCK", "security_attributes" = {}, "skip_source_dest_check" = false, "state" = "AVAILABLE", "subnet_id" = "MOCK_OCID_SUBNET", "time_created" = "mock-value", "vlan_id" = "MOCK_OCID_MOCK" }
  }
  mock_data "oci_identity_availability_domains" {
    defaults = { "availability_domains" = [{ "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-1" }, { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-2" }, { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-3" }], "id" = "MOCK_OCID_DOMAINS" }
  }
  mock_resource "oci_container_instances_container_instance" {
    defaults = { "container_count" = 1, "id" = "MOCK_OCID_INSTANCE", "lifecycle_details" = "mock-value", "system_tags" = {}, "tenant_id" = "MOCK_OCID_MOCK", "time_created" = "mock-value", "time_updated" = "mock-value", "volume_count" = 1 }
  }
}
variables {
  name             = "compatibility"
  compartment_ocid = "MOCK_OCID_COMPARTMENT"
  vnics            = [{ "subnet_id" = "MOCK_OCID_SUBNET" }]
  containers       = [{ "image_url" = "docker.io/library/nginx:stable" }]
}

run "oci9_plan" {
  command = plan
}
