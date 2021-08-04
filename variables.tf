variable "ssh_key_public" {
  default     = "~/ya_rsa.pub"
  description = "Path to the SSH public key for accessing cloud instances. Used for creating AWS keypair."
}

variable "ssh_key_private" {
  default     = "~/ya_rsa"
  description = "Path to the SSH public key for accessing cloud instances. Used for creating AWS keypair."
}

variable "region" {
  default = "eu-frankfurt-1" 
  description = "Tenancy region"
}

variable "image_id" {
  type = map(string)
  default = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaymguk5srho2luw7w627fm3sshgtgpsfkzmeiec3qrrwsy3ys76fa"
  }
}

variable "compartment_name" {
    type = string
}

variable "compartment_state" {
    type = string  
    default = "ACTIVE"
}

variable "compartment_access_level" {
    type = string
    default = "ACCESSIBLE"
}

variable "instance_name" {
    type = string  
}

variable "instance_shape" {
    type = string  
    default = "VM.Standard.E2.1.Micro"
}

variable "vnic_name" {
    type = string
}

variable "assign_public_ip" {
    type = bool
    default = true  
}

variable "hostname_label" {
    type = string
}

variable "ssh_user" {
    type = string
    default = "opc"
}

variable "remote_exec_command" {
    type = list(string)
    default = null
}

variable "app_tags" {
    type = map(string)  
    default = null
}

variable "vcn_dns_label" {
    type = string
    default = "internal"  
}

variable "vcn_cidr_block" {
    type = string
    default = "172.16.0.0/20"
}

variable "vcn_name" {
    type = string
    default = null
}

variable "subnet_cidr_block" {
    type = string
    default = "172.16.0.0/24"
}

variable "subnet_display_name" {
  type = string
  default = null
}

variable "subnet_dns_label" {
    type = string
    default = null
}

variable "route_table_name" {
    type = string
    default = null
}

variable "IG_name" {
    type = string
    default = null
}

variable "dns_zone_name" {
    type = string
    default= null
}

variable "dns_zone_type" {
    type = string
    default = "PRIMARY"
}

variable "security_list_name" {
    type = string
    default = null
}

variable "egress_rule" {
    type = list(map(string))
    default = null
}

variable "tcp_ingress_rule" {
    type = list(map(string))
    default = null
}

variable "udp_ingress_rule" {
    type = list(map(string))
    default = null
}

variable "create_vcn" {
    type = bool
}

variable "vcn_display_name"{
    type = string
    default = "MQTT"
}

variable "vcn_state" {
    type = string  
    default = "Available"
}