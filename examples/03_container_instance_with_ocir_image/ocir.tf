module "ocir" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-ocir.git?ref=v0.1.0"

  compartment_ocid = var.compartment_ocid
  repository_name  = "foggykitchen/hello-world"
  region           = var.region
  is_public        = false
}
