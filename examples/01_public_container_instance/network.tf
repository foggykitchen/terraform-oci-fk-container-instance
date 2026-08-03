module "vcn" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-vcn.git"

  compartment_ocid = var.compartment_ocid
  name             = "fk-ci-public-vcn"
  vcn_cidr_blocks  = ["10.50.0.0/16"]
  dns_label        = "fkcipub"

  create_internet_gateway = true

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
  }

  security_lists = {
    public_container = {
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
  }

  subnets = {
    public = {
      display_name               = "fk-ci-public-subnet"
      cidr_block                 = "10.50.10.0/24"
      dns_label                  = "public"
      route_table_key            = "public"
      security_list_keys         = ["public_container"]
      prohibit_public_ip_on_vnic = false
    }
  }
}
