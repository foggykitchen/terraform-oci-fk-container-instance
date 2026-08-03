data "oci_identity_availability_domains" "this" {
  count = var.availability_domain == null ? 1 : 0

  compartment_id = coalesce(var.tenancy_ocid, var.compartment_ocid)
}

locals {
  availability_domain = coalesce(
    var.availability_domain,
    try(data.oci_identity_availability_domains.this[0].availability_domains[0].name, null)
  )
}

resource "oci_container_instances_container_instance" "this" {
  availability_domain                  = local.availability_domain
  compartment_id                       = var.compartment_ocid
  container_restart_policy             = var.container_restart_policy
  display_name                         = coalesce(var.display_name, var.name)
  fault_domain                         = var.fault_domain
  graceful_shutdown_timeout_in_seconds = var.graceful_shutdown_timeout_in_seconds
  shape                                = var.shape
  state                                = var.state

  shape_config {
    ocpus         = var.shape_config.ocpus
    memory_in_gbs = try(var.shape_config.memory_in_gbs, null)
  }

  dynamic "vnics" {
    for_each = var.vnics

    content {
      subnet_id              = vnics.value.subnet_id
      defined_tags           = try(vnics.value.defined_tags, {})
      display_name           = coalesce(try(vnics.value.display_name, null), "${var.name}-vnic")
      freeform_tags          = try(vnics.value.freeform_tags, {})
      hostname_label         = try(vnics.value.hostname_label, null)
      is_public_ip_assigned  = try(vnics.value.is_public_ip_assigned, false)
      nsg_ids                = try(vnics.value.nsg_ids, [])
      private_ip             = try(vnics.value.private_ip, null)
      skip_source_dest_check = try(vnics.value.skip_source_dest_check, null)
    }
  }

  dynamic "containers" {
    for_each = var.containers

    content {
      image_url                      = containers.value.image_url
      arguments                      = try(containers.value.arguments, null)
      command                        = try(containers.value.command, null)
      defined_tags                   = try(containers.value.defined_tags, {})
      display_name                   = coalesce(try(containers.value.display_name, null), var.name)
      environment_variables          = try(containers.value.environment_variables, {})
      freeform_tags                  = try(containers.value.freeform_tags, {})
      is_resource_principal_disabled = try(containers.value.is_resource_principal_disabled, null)
      working_directory              = try(containers.value.working_directory, null)

      dynamic "resource_config" {
        for_each = try(containers.value.resource_config, null) == null ? [] : [containers.value.resource_config]

        content {
          memory_limit_in_gbs = try(resource_config.value.memory_limit_in_gbs, null)
          vcpus_limit         = try(resource_config.value.vcpus_limit, null)
        }
      }

      dynamic "health_checks" {
        for_each = try(containers.value.health_checks, [])

        content {
          health_check_type        = health_checks.value.health_check_type
          failure_action           = try(health_checks.value.failure_action, null)
          failure_threshold        = try(health_checks.value.failure_threshold, null)
          initial_delay_in_seconds = try(health_checks.value.initial_delay_in_seconds, null)
          interval_in_seconds      = try(health_checks.value.interval_in_seconds, null)
          name                     = try(health_checks.value.name, null)
          path                     = try(health_checks.value.path, null)
          port                     = health_checks.value.port
          success_threshold        = try(health_checks.value.success_threshold, null)
          timeout_in_seconds       = try(health_checks.value.timeout_in_seconds, null)

          dynamic "headers" {
            for_each = try(health_checks.value.headers, [])

            content {
              name  = headers.value.name
              value = headers.value.value
            }
          }
        }
      }

      dynamic "security_context" {
        for_each = try(containers.value.security_context, null) == null ? [] : [containers.value.security_context]

        content {
          is_non_root_user_check_enabled = try(security_context.value.is_non_root_user_check_enabled, null)
          is_root_file_system_readonly   = try(security_context.value.is_root_file_system_readonly, null)
          run_as_group                   = try(security_context.value.run_as_group, null)
          run_as_user                    = try(security_context.value.run_as_user, null)
          security_context_type          = try(security_context.value.security_context_type, null)

          dynamic "capabilities" {
            for_each = try(security_context.value.capabilities, null) == null ? [] : [security_context.value.capabilities]

            content {
              add_capabilities  = try(capabilities.value.add_capabilities, [])
              drop_capabilities = try(capabilities.value.drop_capabilities, [])
            }
          }
        }
      }

      dynamic "volume_mounts" {
        for_each = try(containers.value.volume_mounts, [])

        content {
          mount_path   = volume_mounts.value.mount_path
          volume_name  = volume_mounts.value.volume_name
          is_read_only = try(volume_mounts.value.is_read_only, null)
          partition    = try(volume_mounts.value.partition, null)
          sub_path     = try(volume_mounts.value.sub_path, null)
        }
      }
    }
  }

  dynamic "image_pull_secrets" {
    for_each = var.image_pull_secrets

    content {
      registry_endpoint = image_pull_secrets.value.registry_endpoint
      secret_type       = image_pull_secrets.value.secret_type
      password          = try(image_pull_secrets.value.password, null)
      secret_id         = try(image_pull_secrets.value.secret_id, null)
      username          = try(image_pull_secrets.value.username, null)
    }
  }

  dynamic "dns_config" {
    for_each = var.dns_config == null ? [] : [var.dns_config]

    content {
      nameservers = try(dns_config.value.nameservers, [])
      options     = try(dns_config.value.options, [])
      searches    = try(dns_config.value.searches, [])
    }
  }

  dynamic "volumes" {
    for_each = var.volumes

    content {
      name          = volumes.value.name
      volume_type   = volumes.value.volume_type
      backing_store = try(volumes.value.backing_store, null)

      dynamic "configs" {
        for_each = try(volumes.value.configs, [])

        content {
          data      = configs.value.data
          file_name = configs.value.file_name
          path      = try(configs.value.path, null)
        }
      }
    }
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

data "oci_core_vnic" "primary" {
  count = length(var.vnics) > 0 ? 1 : 0

  vnic_id = oci_container_instances_container_instance.this.vnics[0].vnic_id
}
