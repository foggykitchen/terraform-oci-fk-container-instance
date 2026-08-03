module "container_instance" {
  source = "../../"

  name                = "fk-ci-public"
  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain

  vnics = [
    {
      subnet_id             = module.vcn.subnet_ids["public"]
      display_name          = "fk-ci-public-vnic"
      hostname_label        = "fkcipublic"
      is_public_ip_assigned = true
    }
  ]

  containers = [
    {
      image_url    = "nginx:alpine"
      display_name = "nginx"
      health_checks = [
        {
          health_check_type        = "HTTP"
          name                     = "http"
          port                     = 80
          path                     = "/"
          initial_delay_in_seconds = 10
          interval_in_seconds      = 30
        }
      ]
    }
  ]
}
