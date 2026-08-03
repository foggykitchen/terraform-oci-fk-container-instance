variable "name" {
  description = "Base display name for OCI Container Instance resources."
  type        = string

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}

variable "compartment_ocid" {
  description = "Compartment OCID where the container instance will be created."
  type        = string
}

variable "tenancy_ocid" {
  description = "Optional tenancy OCID used for availability domain discovery. When null, compartment_ocid is used."
  type        = string
  default     = null
}

variable "availability_domain" {
  description = "Availability domain name for the container instance. When null, the first AD is used."
  type        = string
  default     = null
}

variable "fault_domain" {
  description = "Optional fault domain for the container instance."
  type        = string
  default     = null
}

variable "display_name" {
  description = "Optional display name override for the container instance."
  type        = string
  default     = null
}

variable "shape" {
  description = "OCI Container Instance shape."
  type        = string
  default     = "CI.Standard.E4.Flex"
}

variable "shape_config" {
  description = "Shape configuration for the container instance."
  type = object({
    ocpus         = number
    memory_in_gbs = optional(number)
  })
  default = {
    ocpus         = 1
    memory_in_gbs = 1
  }
}

variable "container_restart_policy" {
  description = "Container restart policy applied to all containers."
  type        = string
  default     = "ALWAYS"

  validation {
    condition     = contains(["ALWAYS", "NEVER", "ON_FAILURE"], var.container_restart_policy)
    error_message = "container_restart_policy must be ALWAYS, NEVER, or ON_FAILURE."
  }
}

variable "state" {
  description = "Target state for the container instance."
  type        = string
  default     = "ACTIVE"

  validation {
    condition     = contains(["ACTIVE", "INACTIVE"], var.state)
    error_message = "state must be ACTIVE or INACTIVE."
  }
}

variable "graceful_shutdown_timeout_in_seconds" {
  description = "Seconds given to container processes to stop gracefully before deletion."
  type        = number
  default     = null
}

variable "vnics" {
  description = "VNIC definitions for the container instance."
  type = list(object({
    subnet_id              = string
    display_name           = optional(string)
    hostname_label         = optional(string)
    is_public_ip_assigned  = optional(bool, false)
    nsg_ids                = optional(list(string), [])
    private_ip             = optional(string)
    skip_source_dest_check = optional(bool)
    defined_tags           = optional(map(string), {})
    freeform_tags          = optional(map(string), {})
  }))

  validation {
    condition     = length(var.vnics) > 0
    error_message = "vnics must contain at least one VNIC definition."
  }
}

variable "containers" {
  description = "Container definitions deployed on the container instance."
  type = list(object({
    image_url                      = string
    display_name                   = optional(string)
    command                        = optional(list(string))
    arguments                      = optional(list(string))
    environment_variables          = optional(map(string), {})
    working_directory              = optional(string)
    is_resource_principal_disabled = optional(bool)
    defined_tags                   = optional(map(string), {})
    freeform_tags                  = optional(map(string), {})
    resource_config = optional(object({
      memory_limit_in_gbs = optional(number)
      vcpus_limit         = optional(number)
    }))
    health_checks = optional(list(object({
      health_check_type        = string
      name                     = optional(string)
      port                     = number
      path                     = optional(string)
      failure_action           = optional(string)
      failure_threshold        = optional(number)
      initial_delay_in_seconds = optional(number)
      interval_in_seconds      = optional(number)
      success_threshold        = optional(number)
      timeout_in_seconds       = optional(number)
      headers = optional(list(object({
        name  = string
        value = string
      })), [])
    })), [])
    security_context = optional(object({
      security_context_type          = optional(string)
      is_non_root_user_check_enabled = optional(bool)
      is_root_file_system_readonly   = optional(bool)
      run_as_group                   = optional(number)
      run_as_user                    = optional(number)
      capabilities = optional(object({
        add_capabilities  = optional(list(string), [])
        drop_capabilities = optional(list(string), [])
      }))
    }))
    volume_mounts = optional(list(object({
      mount_path   = string
      volume_name  = string
      is_read_only = optional(bool)
      partition    = optional(number)
      sub_path     = optional(string)
    })), [])
  }))

  validation {
    condition     = length(var.containers) > 0
    error_message = "containers must contain at least one container definition."
  }
}

variable "image_pull_secrets" {
  description = "Image pull secrets used for private registries such as OCIR."
  type = list(object({
    registry_endpoint = string
    secret_type       = string
    username          = optional(string)
    password          = optional(string)
    secret_id         = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for secret in var.image_pull_secrets : contains(["BASIC", "VAULT"], secret.secret_type)
    ])
    error_message = "image_pull_secrets[*].secret_type must be BASIC or VAULT."
  }
}

variable "dns_config" {
  description = "Optional DNS resolver configuration for containers."
  type = object({
    nameservers = optional(list(string), [])
    options     = optional(list(string), [])
    searches    = optional(list(string), [])
  })
  default = null
}

variable "volumes" {
  description = "Volume definitions attached to the container instance."
  type = list(object({
    name          = string
    volume_type   = string
    backing_store = optional(string)
    configs = optional(list(object({
      data      = string
      file_name = string
      path      = optional(string)
    })), [])
  }))
  default = []
}

variable "defined_tags" {
  description = "Defined tags applied to the container instance."
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Freeform tags applied to the container instance."
  type        = map(string)
  default     = {}
}
