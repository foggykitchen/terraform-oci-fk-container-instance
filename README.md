# terraform-oci-fk-container-instance

This repository contains a reusable **Terraform/OpenTofu module** and progressive examples for deploying **Oracle Cloud Infrastructure (OCI) Container Instances**.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and is designed to work cleanly with reusable infrastructure modules such as **`terraform-oci-fk-vcn`**, **`terraform-oci-fk-loadbalancer`**, and **`terraform-oci-fk-ocir`**.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Used By

This module is designed as a composable container runtime building block for FoggyKitchen OCI and multicloud training architectures.

## Purpose

The goal of this module is to provide a **clean, composable, and educational reference implementation** for OCI Container Instances:

- Focused on OCI-native container instance primitives
- Suitable for public, private, and load-balanced container deployments
- Designed for hands-on learning, module composition, and comparisons with VM-based compute patterns

This is **not** a full application platform, Kubernetes replacement, or landing zone. It is a **learning-first, architecture-aware module**.

---

## What the module does

The module creates:

- OCI Container Instance
- One or more containers inside the container instance
- One or more VNIC attachments
- Optional image pull secrets for private registries such as OCIR
- Optional DNS resolver configuration
- Optional container health checks
- Optional container resource limits
- Optional config file or emptyDir volume attachments
- Optional container-level and instance-level security context

The module intentionally does **not** create:

- VCNs, subnets, route tables, gateways, or security lists
- Load Balancers
- OCIR repositories or image build pipelines
- Vault secrets or IAM policies
- DNS zones or public records

Each of those concerns belongs in its own dedicated module.

---

## Repository Structure

```bash
terraform-oci-fk-container-instance/
├── examples/
│   ├── 01_public_container_instance/
│   ├── 02_private_container_instance_with_load_balancer/
│   ├── 03_container_instance_with_ocir_image/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── LICENSE
├── SUPPORT.md
└── README.md
```

All examples are runnable and demonstrate **incremental container instance patterns**, starting from a public container instance and progressing to private load-balanced and OCIR-backed `foggykitchen-hello-world` deployments.

---

## Example Usage

### Public container instance

```hcl
module "container_instance" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-container-instance.git?ref=v0.1.0"

  name             = "fk-ci-public"
  compartment_ocid = var.compartment_ocid

  vnics = [
    {
      subnet_id             = var.subnet_id
      is_public_ip_assigned = true
      hostname_label        = "fkcipublic"
    }
  ]

  containers = [
    {
      image_url    = "nginx:alpine"
      display_name = "nginx"
      health_checks = [
        {
          health_check_type = "HTTP"
          name              = "http"
          port              = 80
          path              = "/"
        }
      ]
    }
  ]
}
```

### Private container instance with image pull secret

```hcl
module "container_instance" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-container-instance.git?ref=v0.1.0"

  name             = "fk-ci-ocir"
  compartment_ocid = var.compartment_ocid

  vnics = [
    {
      subnet_id = var.private_subnet_id
    }
  ]

  image_pull_secrets = [
    {
      registry_endpoint = var.ocir_registry
      secret_type       = "BASIC"
      username          = base64encode(var.ocir_username)
      password          = base64encode(var.ocir_auth_token)
    }
  ]

  containers = [
    {
      image_url    = var.image_url
      display_name = "app"
    }
  ]
}
```

---

## Module Inputs

### Core inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `name` | `string` | Yes | Base display name used for OCI Container Instance resources |
| `compartment_ocid` | `string` | Yes | OCI compartment OCID |
| `tenancy_ocid` | `string` | No | Optional tenancy OCID used for availability domain discovery |
| `availability_domain` | `string` | No | Optional availability domain override |
| `fault_domain` | `string` | No | Optional fault domain |
| `display_name` | `string` | No | Optional display name override |
| `shape` | `string` | No | OCI Container Instance shape |
| `shape_config` | `object` | No | OCPU and memory configuration |
| `container_restart_policy` | `string` | No | `ALWAYS`, `NEVER`, or `ON_FAILURE` |
| `state` | `string` | No | `ACTIVE` or `INACTIVE` |

### Networking and containers

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `vnics` | `list(object)` | Yes | VNIC definitions, including subnet, public IP, hostname, NSGs, and private IP |
| `containers` | `list(object)` | Yes | Container definitions, including image URL, command, environment variables, health checks, limits, security context, and volume mounts |
| `image_pull_secrets` | `list(object)` | No | BASIC or VAULT image pull secrets for private registries |
| `dns_config` | `object` | No | Optional container DNS resolver settings |
| `volumes` | `list(object)` | No | Optional config file or emptyDir volumes |

### Tags

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `defined_tags` | `map(string)` | No | Defined tags |
| `freeform_tags` | `map(string)` | No | Freeform tags |

---

## Outputs

| Output | Description |
|--------|-------------|
| `container_instance_id` | OCI Container Instance OCID |
| `container_instance_name` | OCI Container Instance display name |
| `container_instance_state` | OCI Container Instance lifecycle state |
| `container_count` | Number of containers on the container instance |
| `containers` | Container summaries returned by OCI |
| `vnic_ids` | VNIC OCIDs attached to the container instance |
| `primary_vnic_id` | Primary VNIC OCID |
| `primary_private_ip` | Primary VNIC private IP address |
| `primary_public_ip` | Primary VNIC public IP address, when assigned |
| `volume_count` | Number of attached volumes |

---

## Related Resources

- [Training examples](examples/)
- [FoggyKitchen OCI VCN Module](https://github.com/foggykitchen/terraform-oci-fk-vcn)
- [FoggyKitchen OCI Load Balancer Module](https://github.com/foggykitchen/terraform-oci-fk-loadbalancer)
- [FoggyKitchen OCI OCIR Module](https://github.com/foggykitchen/terraform-oci-fk-ocir)
- [FoggyKitchen OCI Compute Module](https://github.com/foggykitchen/terraform-oci-fk-compute)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
