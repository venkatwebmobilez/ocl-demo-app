data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

locals {
  selected_availability_domain = var.availability_domain != "" ? var.availability_domain : data.oci_identity_availability_domains.ads.availability_domains[0].name
  ssh_public_key               = var.ssh_public_key != "" ? trimspace(var.ssh_public_key) : (var.ssh_public_key_path != "" ? trimspace(file(pathexpand(var.ssh_public_key_path))) : "")
}

resource "terraform_data" "required_inputs" {
  input = {
    tenancy_ocid      = var.tenancy_ocid
    user_ocid         = var.user_ocid
    fingerprint       = var.fingerprint
    private_key_path  = var.private_key_path
    region            = var.region
    compartment_id    = var.compartment_id
    instance_image_id = var.instance_image_id
  }

  lifecycle {
    precondition {
      condition = alltrue([
        var.tenancy_ocid != null,
        var.user_ocid != null,
        var.fingerprint != null,
        var.private_key_path != null,
        var.region != null,
        var.compartment_id != null,
        var.instance_image_id != null,
      ])
      error_message = "Set tenancy_ocid, user_ocid, fingerprint, private_key_path, region, compartment_id, and instance_image_id."
    }
  }
}

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr_block]
  display_name   = var.vcn_display_name
  dns_label      = var.vcn_dns_label
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.internet_gateway_display_name
  enabled        = true
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.route_table_display_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = var.security_list_display_name

  dynamic "ingress_security_rules" {
    for_each = var.allowed_ssh_cidrs
    content {
      protocol = "6"
      source   = ingress_security_rules.value

      tcp_options {
        min = 22
        max = 22
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = var.allowed_app_cidrs
    content {
      protocol = "6"
      source   = ingress_security_rules.value

      tcp_options {
        min = var.app_port
        max = var.app_port
      }
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "public" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = var.public_subnet_cidr_block
  display_name               = var.public_subnet_display_name
  dns_label                  = var.public_subnet_dns_label
  prohibit_public_ip_on_vnic = false
  prohibit_internet_ingress  = false
  route_table_id             = oci_core_route_table.public.id
  security_list_ids          = [oci_core_security_list.public.id]
}

resource "oci_core_instance" "this" {
  compartment_id      = var.compartment_id
  availability_domain = local.selected_availability_domain
  shape               = var.instance_shape
  display_name        = var.instance_display_name

  source_details {
    source_type = "image"
    source_id   = var.instance_image_id
  }

  dynamic "shape_config" {
    for_each = var.instance_shape_config == null ? [] : [var.instance_shape_config]
    content {
      ocpus         = shape_config.value.ocpus
      memory_in_gbs = shape_config.value.memory_in_gbs
    }
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public.id
    assign_public_ip = true
    hostname_label   = "tfoci"
  }

  metadata = {
    ssh_authorized_keys = local.ssh_public_key
  }

  lifecycle {
    precondition {
      condition     = local.ssh_public_key != ""
      error_message = "Provide ssh_public_key or ssh_public_key_path."
    }
  }
}

data "oci_core_vnic_attachments" "instance" {
  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.this.id
}

data "oci_core_vnic" "primary" {
  vnic_id = data.oci_core_vnic_attachments.instance.vnic_attachments[0].vnic_id
}
