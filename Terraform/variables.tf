variable "tenancy_ocid" {
  description = "OCI tenancy OCID used for provider authentication."
  type        = string
  default     = null
}

variable "user_ocid" {
  description = "OCI user OCID used for provider authentication."
  type        = string
  default     = null
}

variable "fingerprint" {
  description = "API key fingerprint used for provider authentication."
  type        = string
  default     = null
}

variable "private_key_path" {
  description = "Path to the OCI API private key used for provider authentication."
  type        = string
  default     = null
}

variable "region" {
  description = "OCI region used for provider authentication."
  type        = string
  default     = null
}

variable "compartment_id" {
  description = "OCID of the compartment that will contain the resources."
  type        = string
  default     = null
}

variable "availability_domain" {
  description = "Availability domain for the instance. Leave empty to use the first AD in the region."
  type        = string
  default     = ""
}

variable "vcn_cidr_block" {
  description = "CIDR block for the VCN."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vcn_display_name" {
  description = "Display name for the VCN."
  type        = string
  default     = "tf-vcn"
}

variable "vcn_dns_label" {
  description = "DNS label for the VCN."
  type        = string
  default     = "tfvcn"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_display_name" {
  description = "Display name for the public subnet."
  type        = string
  default     = "tf-public-subnet"
}

variable "public_subnet_dns_label" {
  description = "DNS label for the public subnet."
  type        = string
  default     = "public"
}

variable "internet_gateway_display_name" {
  description = "Display name for the internet gateway."
  type        = string
  default     = "tf-internet-gateway"
}

variable "route_table_display_name" {
  description = "Display name for the route table."
  type        = string
  default     = "tf-public-route-table"
}

variable "security_list_display_name" {
  description = "Display name for the security list."
  type        = string
  default     = "tf-public-security-list"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to reach SSH on the public subnet."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_app_cidrs" {
  description = "CIDR blocks allowed to reach the Spring Boot app."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "app_port" {
  description = "TCP port exposed by the Spring Boot app."
  type        = number
  default     = 8080
}

variable "instance_display_name" {
  description = "Display name for the compute instance."
  type        = string
  default     = "tf-oci-instance"
}

variable "instance_shape" {
  description = "Compute shape for the instance."
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "instance_shape_config" {
  description = "Optional shape_config for flexible shapes."
  type = object({
    ocpus         = number
    memory_in_gbs = number
  })
  default = null
}

variable "instance_image_id" {
  description = "Region-specific OCID of the image to boot from."
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "SSH public key content. Use either this or ssh_public_key_path."
  type        = string
  default     = ""
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file. Use either this or ssh_public_key."
  type        = string
  default     = ""
}
