module "load_balancer" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-loadbalancer.git"

  compartment_ocid      = var.compartment_ocid
  name                  = "fk-ci-ocir-public-lb"
  subnet_ids            = [module.vcn.subnet_ids["public_lb"]]
  is_private            = false
  reserved_public_ip_id = module.public_ip.id

  health_checker = {
    protocol = "HTTP"
    port     = 80
    url_path = "/"
  }

  listener = {
    name     = "http"
    port     = 80
    protocol = "HTTP"
  }

  backends = {
    container = {
      ip_address = module.container_instance.primary_private_ip
      port       = 80
    }
  }
}
