module "container_instance" {
  source = "../../"

  name                = "fk-ci-ocir"
  tenancy_ocid        = var.tenancy_ocid
  compartment_ocid    = var.compartment_ocid
  availability_domain = var.availability_domain

  depends_on = [terraform_data.hello_world_build_push]

  vnics = [
    {
      subnet_id      = module.vcn.subnet_ids["private_container"]
      display_name   = "fk-ci-ocir-vnic"
      hostname_label = "fkciocir"
    }
  ]

  image_pull_secrets = [
    {
      registry_endpoint = module.ocir.registry
      secret_type       = "BASIC"
      username          = base64encode(local.effective_ocir_login_username)
      password          = base64encode(local.effective_ocir_auth_token)
    }
  ]

  containers = [
    {
      image_url    = local.hello_world_image
      display_name = "foggykitchen-hello-world"
      environment_variables = {
        FOGGYKITCHEN_EXAMPLE = "03_container_instance_with_ocir_image"
      }
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
