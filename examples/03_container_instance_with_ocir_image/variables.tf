variable "tenancy_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "region" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "availability_domain" {
  type    = string
  default = null
}

variable "ocir_username" {
  description = "OCIR username in namespace/username format."
  type        = string
  default     = null
}

variable "ocir_auth_token" {
  description = "OCI auth token used by OCIR image pull secret."
  type        = string
  sensitive   = true
  default     = null
}

variable "ocir_user_name" {
  description = "Backward-compatible OCIR username variable used by older FoggyKitchen function examples."
  type        = string
  default     = null
}

variable "ocir_user_password" {
  description = "Backward-compatible OCIR auth token variable used by older FoggyKitchen function examples."
  type        = string
  sensitive   = true
  default     = null
}

variable "image_tag" {
  description = "Image tag to deploy from the OCIR repository."
  type        = string
  default     = "latest"
}

variable "build_and_push_image" {
  description = "Build and push foggykitchen-hello-world to OCIR before creating the container instance."
  type        = bool
  default     = true
}

variable "docker_platform" {
  description = "Docker target platform used when building the OCIR image."
  type        = string
  default     = "linux/amd64"
}

variable "hello_world_repo_url" {
  description = "Git repository URL for the FoggyKitchen hello world application source."
  type        = string
  default     = "https://github.com/foggykitchen/foggykitchen-hello-world.git"
}

variable "hello_world_repo_ref" {
  description = "Git branch or tag used when cloning the FoggyKitchen hello world application source."
  type        = string
  default     = "master"
}

variable "hello_world_source_hash" {
  description = "Optional manual build trigger. Change this value to force a rebuild and push of the image."
  type        = string
  default     = "v2"
}
