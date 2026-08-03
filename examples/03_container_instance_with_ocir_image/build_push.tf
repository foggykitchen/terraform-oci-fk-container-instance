locals {
  effective_ocir_username       = coalesce(var.ocir_username, var.ocir_user_name)
  effective_ocir_auth_token     = coalesce(var.ocir_auth_token, var.ocir_user_password)
  effective_ocir_login_username = startswith(local.effective_ocir_username, "${module.ocir.namespace}/") ? local.effective_ocir_username : "${module.ocir.namespace}/${local.effective_ocir_username}"
  hello_world_source_dir        = "${path.root}/.terraform/foggykitchen-hello-world"
  hello_world_image             = "${module.ocir.image_prefix}:${var.image_tag}"
}

resource "terraform_data" "hello_world_build_push" {
  count = var.build_and_push_image ? 1 : 0

  triggers_replace = {
    image       = local.hello_world_image
    repo_url    = var.hello_world_repo_url
    repo_ref    = var.hello_world_repo_ref
    source_hash = var.hello_world_source_hash
  }

  depends_on = [module.ocir]

  provisioner "local-exec" {
    command = "echo \"$OCIR_AUTH_TOKEN\" | docker login ${module.ocir.registry} --username '${local.effective_ocir_login_username}' --password-stdin"

    environment = {
      OCIR_AUTH_TOKEN = local.effective_ocir_auth_token
    }
  }

  provisioner "local-exec" {
    command = "docker image rm ${local.hello_world_image} -f || true"
  }

  provisioner "local-exec" {
    command = "rm -rf '${local.hello_world_source_dir}' && git clone --depth 1 --branch '${var.hello_world_repo_ref}' '${var.hello_world_repo_url}' '${local.hello_world_source_dir}'"
  }

  provisioner "local-exec" {
    command     = "docker build --platform ${var.docker_platform} -t ${local.hello_world_image} ."
    working_dir = local.hello_world_source_dir
  }

  provisioner "local-exec" {
    command     = "docker push ${local.hello_world_image}"
    working_dir = local.hello_world_source_dir
  }
}
