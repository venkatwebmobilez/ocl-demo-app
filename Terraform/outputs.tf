output "vcn_id" {
  value       = oci_core_vcn.this.id
  description = "OCID of the VCN."
}

output "subnet_id" {
  value       = oci_core_subnet.public.id
  description = "OCID of the public subnet."
}

output "instance_id" {
  value       = oci_core_instance.this.id
  description = "OCID of the compute instance."
}

output "private_ip" {
  value       = data.oci_core_vnic.primary.private_ip_address
  description = "Private IP assigned to the instance."
}

output "public_ip" {
  value       = data.oci_core_vnic.primary.public_ip_address
  description = "Public IP assigned to the instance."
}

