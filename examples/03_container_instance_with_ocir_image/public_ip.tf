module "public_ip" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-public-ip.git"

  name                         = "fk-ci-ocir-lb-public-ip"
  compartment_ocid             = var.compartment_ocid
  ignore_private_ip_id_changes = true
}
