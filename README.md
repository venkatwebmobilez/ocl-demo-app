# OracleCloudInfrastructure

Terraform for a minimal Oracle Cloud Infrastructure stack:

- a VCN
- a public subnet
- an internet gateway
- a route table
- a security list for SSH and outbound traffic
- one compute instance

The repo also includes a GitHub Actions workflow for Terraform validation and manual deployment.

## Layout

```text
Terraform/
  main.tf
  outputs.tf
  provider.tf
  terraform.tf
  terraform.tfvars.example
  variables.tf
.github/workflows/OCI.yml
HelpScript.ps1
```

## Prerequisites

- Terraform installed locally
- OCI API key values available as environment variables or in `terraform.tfvars`
- An existing OCI compartment OCID
- An OCI image OCID for the compute instance
- An SSH public key

Oracle recommends using a region-specific image OCID instead of discovering the latest image dynamically, because image lists change over time. See Oracle's Terraform image guidance for details.

## Local usage

You can either export `TF_VAR_*` environment variables or fill in `Terraform/terraform.tfvars`.

Required provider variables:

- `TF_VAR_tenancy_ocid`
- `TF_VAR_user_ocid`
- `TF_VAR_fingerprint`
- `TF_VAR_private_key_path`
- `TF_VAR_region`

Required stack variables:

- `TF_VAR_compartment_id`
- `TF_VAR_instance_image_id`
- `TF_VAR_ssh_public_key` or `TF_VAR_ssh_public_key_path`

Then run:

```bash
cd Terraform
terraform init
terraform plan
terraform apply
```

## GitHub Actions

The workflow expects these secrets for manual deploys:

- `OCI_TENANCY_OCID`
- `OCI_USER_OCID`
- `OCI_FINGERPRINT`
- `OCI_REGION`
- `OCI_PRIVATE_KEY`
- `OCI_COMPARTMENT_OCID`
- `OCI_IMAGE_OCID`
- `OCI_SSH_PUBLIC_KEY`

Validation runs on pull requests and pushes. Manual dispatch can run `plan` or `apply`.
