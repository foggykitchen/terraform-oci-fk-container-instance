# OCI Container Instances with Terraform/OpenTofu - Training Examples

This directory contains runnable examples for the **terraform-oci-fk-container-instance** module.
The examples focus on practical OCI Container Instance deployment patterns, from a public single-container path to private, load-balanced, and OCIR-backed deployments.

These examples are part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and are used across OCI and multicloud courses covering networking, containers, traffic distribution, and architecture fundamentals.

---

## Published Examples

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Public Container Instance** | public subnet path, `terraform-oci-fk-vcn`, public VNIC, Docker Hub image |
| 02 | **Private Container Instance with Load Balancer** | private container subnet, public LB subnet, `terraform-oci-fk-public-ip`, `terraform-oci-fk-loadbalancer`, static backend |
| 03 | **Container Instance with FoggyKitchen Hello World from OCIR** | `foggykitchen-hello-world`, `terraform-oci-fk-ocir`, private image pull secret, private subnet with NAT path |

---

## How to Use

The example directory contains:

- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A `terraform.tfvars.example` file with the required OCI variables
- A minimal, runnable architecture built from FoggyKitchen modules

Before running an example, create a local variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

To run the public container instance example:

```bash
cd examples/01_public_container_instance
tofu init
tofu plan
tofu apply
```

To run the private load-balanced example:

```bash
cd examples/02_private_container_instance_with_load_balancer
tofu init
tofu plan
tofu apply
```

To run the OCIR image example:

```bash
cd examples/03_container_instance_with_ocir_image
tofu init
tofu plan
tofu apply
```

---

## Design Principles

- One example = one architectural goal
- No raw OCI resources in example configurations
- Clear separation of concerns between networking, container runtime, registry, and load balancing
- Examples designed to integrate with other FoggyKitchen modules such as VCN, Load Balancer, and OCIR

---

## Related Resources

- [FoggyKitchen OCI Container Instance Module (terraform-oci-fk-container-instance)](../)
- [FoggyKitchen OCI VCN Module (terraform-oci-fk-vcn)](https://github.com/foggykitchen/terraform-oci-fk-vcn)
- [FoggyKitchen OCI Load Balancer Module (terraform-oci-fk-loadbalancer)](https://github.com/foggykitchen/terraform-oci-fk-loadbalancer)
- [FoggyKitchen OCI OCIR Module (terraform-oci-fk-ocir)](https://github.com/foggykitchen/terraform-oci-fk-ocir)

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
