module "vcn" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git"

  compartment_ocid = var.compartment_ocid
  name             = "fk-ci-ocir-vcn"
  vcn_cidr_blocks  = ["10.52.0.0/16"]
  dns_label        = "fkciocir"

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true

  route_tables = {
    public = {
      route_rules = [
        {
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "internet_gateway"
        }
      ]
    }
    private = {
      route_rules = [
        {
          destination        = "0.0.0.0/0"
          destination_type   = "CIDR_BLOCK"
          network_entity_key = "nat_gateway"
        },
        {
          destination        = "all-services"
          destination_type   = "SERVICE_CIDR_BLOCK"
          network_entity_key = "service_gateway"
        }
      ]
    }
  }

  security_lists = {
    public_lb = {
      ingress_rules = [
        {
          protocol = "6"
          source   = "0.0.0.0/0"
          tcp_options = {
            min = 80
            max = 80
          }
        }
      ]
      egress_rules = [
        {
          protocol    = "all"
          destination = "0.0.0.0/0"
        }
      ]
    }
    private_container = {
      ingress_rules = [
        {
          protocol = "6"
          source   = "10.52.10.0/24"
          tcp_options = {
            min = 80
            max = 80
          }
        }
      ]
      egress_rules = [
        {
          protocol    = "all"
          destination = "0.0.0.0/0"
        }
      ]
    }
  }

  subnets = {
    public_lb = {
      display_name               = "fk-ci-ocir-public-lb-subnet"
      cidr_block                 = "10.52.10.0/24"
      dns_label                  = "publiclb"
      route_table_key            = "public"
      security_list_keys         = ["public_lb"]
      prohibit_public_ip_on_vnic = false
    }
    private_container = {
      display_name               = "fk-ci-ocir-private-subnet"
      cidr_block                 = "10.52.20.0/24"
      dns_label                  = "privateci"
      route_table_key            = "private"
      security_list_keys         = ["private_container"]
      prohibit_public_ip_on_vnic = true
      prohibit_internet_ingress  = true
    }
  }
}
