# Synthetic fixtures only. Every run is plan-only; no tenancy credentials are used.
mock_provider "oci" {
  mock_data "oci_core_services" {
    defaults = { "id" = "MOCK_OCID_SERVICES", "services" = [{ "cidr_block" = "all-fra-services-in-oracle-services-network", "description" = "mock-value", "id" = "mock-service", "name" = "All FRA Services In Oracle Services Network" }] }
  }
  mock_data "oci_core_vnic" {
    defaults = { "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "compartment_id" = "MOCK_OCID_COMPARTMENT", "defined_tags" = {}, "display_name" = "compatibility", "freeform_tags" = {}, "hostname_label" = "mock-value", "id" = "MOCK_OCID_VNIC", "ipv6addresses" = ["mock-value"], "is_primary" = false, "mac_address" = "mock-value", "nsg_ids" = ["mock-value"], "private_ip_address" = "10.0.0.10", "public_ip_address" = "10.0.0.10", "route_table_id" = "MOCK_OCID_MOCK", "security_attributes" = {}, "skip_source_dest_check" = false, "state" = "AVAILABLE", "subnet_id" = "MOCK_OCID_SUBNET", "time_created" = "mock-value", "vlan_id" = "MOCK_OCID_MOCK" }
  }
  mock_data "oci_identity_availability_domains" {
    defaults = { "availability_domains" = [{ "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-1" }, { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-2" }, { "compartment_id" = "MOCK_OCID_COMPARTMENT", "id" = "MOCK_OCID_MOCK", "name" = "MOCK:EU-FRANKFURT-1-AD-3" }], "id" = "MOCK_OCID_DOMAINS" }
  }
  mock_resource "oci_container_instances_container_instance" {
    defaults = { "container_count" = 1, "id" = "MOCK_OCID_INSTANCE", "lifecycle_details" = "mock-value", "system_tags" = {}, "tenant_id" = "MOCK_OCID_MOCK", "time_created" = "mock-value", "time_updated" = "mock-value", "volume_count" = 1 }
  }
  mock_resource "oci_core_dhcp_options" {
    defaults = { "id" = "MOCK_OCID_OPTIONS", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_internet_gateway" {
    defaults = { "id" = "MOCK_OCID_GATEWAY", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_nat_gateway" {
    defaults = { "id" = "MOCK_OCID_GATEWAY", "nat_ip" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_public_ip" {
    defaults = { "assigned_entity_id" = "MOCK_OCID_MOCK", "assigned_entity_type" = "mock-value", "availability_domain" = "MOCK:EU-FRANKFURT-1-AD-1", "id" = "MOCK_OCID_IP", "ip_address" = "10.0.0.10", "scope" = "mock-value", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_route_table" {
    defaults = { "id" = "MOCK_OCID_TABLE", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_security_list" {
    defaults = { "id" = "MOCK_OCID_LIST", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_service_gateway" {
    defaults = { "block_traffic" = false, "id" = "MOCK_OCID_GATEWAY", "state" = "AVAILABLE", "time_created" = "mock-value" }
  }
  mock_resource "oci_core_subnet" {
    defaults = { "id" = "MOCK_OCID_SUBNET", "ipv6virtual_router_ip" = "mock-value", "state" = "AVAILABLE", "subnet_domain_name" = "mock-value", "time_created" = "mock-value", "virtual_router_ip" = "mock-value", "virtual_router_mac" = "mock-value" }
  }
  mock_resource "oci_core_vcn" {
    defaults = { "byoipv6cidr_blocks" = ["mock-value"], "default_dhcp_options_id" = "MOCK_OCID_MOCK", "default_route_table_id" = "MOCK_OCID_MOCK", "default_security_list_id" = "MOCK_OCID_MOCK", "id" = "MOCK_OCID_VCN", "ipv6cidr_blocks" = ["mock-value"], "state" = "AVAILABLE", "time_created" = "mock-value", "vcn_domain_name" = "mock-value" }
  }
  mock_resource "oci_load_balancer_backend" {
    defaults = { "id" = "MOCK_OCID_BACKEND", "name" = "compatibility", "state" = "AVAILABLE" }
  }
  mock_resource "oci_load_balancer_backend_set" {
    defaults = { "backend" = [{ "backup" = false, "drain" = false, "ip_address" = "10.0.0.10", "max_connections" = 1, "name" = "compatibility", "offline" = false, "port" = 1, "weight" = 1 }], "id" = "MOCK_OCID_SET", "state" = "AVAILABLE" }
  }
  mock_resource "oci_load_balancer_listener" {
    defaults = { "id" = "MOCK_OCID_LISTENER", "state" = "AVAILABLE" }
  }
  mock_resource "oci_load_balancer_load_balancer" {
    defaults = { "id" = "MOCK_OCID_BALANCER", "ip_address_details" = [{ "ip_address" = "10.0.0.10", "is_public" = false, "reserved_ip" = [{ "id" = "MOCK_OCID_MOCK" }] }], "ip_addresses" = ["mock-value"], "state" = "AVAILABLE", "system_tags" = {}, "time_created" = "mock-value" }
  }
}
variables {
  tenancy_ocid     = "MOCK_OCID_TENANCY"
  user_ocid        = "MOCK_OCID_MOCK"
  fingerprint      = "compatibility"
  private_key_path = "/unused-by-mock"
  region           = "eu-frankfurt-1"
  compartment_ocid = "MOCK_OCID_COMPARTMENT"
}

run "oci9_plan" {
  command = plan
}
