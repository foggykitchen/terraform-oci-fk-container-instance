module "ocir" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-ocir.git?ref=v0.2.0" # TODO: tag not yet released

  compartment_ocid = var.compartment_ocid
  repository_name  = "foggykitchen/hello-world"
  region           = var.region
  is_public        = false
}
