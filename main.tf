terraform {
   backend "s3" {
    endpoint                    = "https://frd8bsyrgar7.compat.objectstorage.eu-frankfurt-1.oraclecloud.com"
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
    skip_credentials_validation = true
    bucket                      = "tf-state"
    key                         = "mqtt/terraform.tfstate"
    region                      = "eu-frankfurt-1"
  }
  required_providers {
    oci = {
        source  = "hashicorp/oci"
        version = ">= 4.0.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

locals {
    vcn_id              = try(var.create_vcn ? module.oci-network.vcn_id : data.oci_core_vcns.existing_vcns.virtual_networks[0].id)
    vcn_cidr            = try(var.create_vcn ? module.oci-network.vcn_cidr : data.oci_core_vcns.existing_vcns.virtual_networks[0].cidr_blocks[0])
    TG_ADMIN            = data.sops_file.secret.data["TG_ADMIN"]
    TG_TOKEN            = data.sops_file.secret.data["TG_TOKEN"]
}



module "oci-identity-managment" {
    source = "git@github.com:Randsw/oci-terraform-identity-managment.git"

    tenancy_id = data.sops_file.secret.data["tenancy"]
    compartment_name = "MQTT"
    exist_compartment_id = data.sops_file.secret.data["tenancy"]
    create_group = false
    create_user = false
    tags = {
        app = "MQTT"
    }
    add_user_to_group = false
    exist_user_name = "Deployer"
    exist_group_name = "DevOps"
}

module "oci-security" {
    source = "git@github.com:Randsw/oci-terraform-security.git"

    vcn_id             = local.vcn_id
    vcn_cidr           = local.vcn_cidr 
    compartment_id     = module.oci-identity-managment.compartm_id
    app_tags           = var.app_tags
    security_list_name = var.security_list_name
    egress_rule        = var.egress_rule
    tcp_ingress_rule   = var.tcp_ingress_rule
    udp_ingress_rule   = var.udp_ingress_rule
}

module "oci-app-instance" {
    source = "git@github.com:Randsw/oci-terraform-instance.git"

    subnet_id           = module.oci-network.subnet_id
    ssh_key_public      = var.ssh_key_public
    ssh_key_private     = var.ssh_key_private
    region              = var.region
    image_id            = var.image_id
    compartment_id      = module.oci-identity-managment.compartm_id
    instance_name       = var.instance_name
    vnic_name           = var.vnic_name
    assign_public_ip    = var.assign_public_ip
    hostname_label      = var.hostname_label
    ssh_user            = var.ssh_user
    remote_exec_command = var.remote_exec_command
    app_tags            = var.app_tags
}

module "oci-network" {
    source = "git@github.com:Randsw/oci-terraform-network.git"

    compartment_id               = module.oci-identity-managment.compartm_id
    security_list_ids            = "${split(",", module.oci-security.security_list_id)}"
    instance_public_ip           = module.oci-app-instance.public-ip-address
    app_tags                     = var.app_tags
    vcn_dns_label                = var.vcn_dns_label  
    vcn_cidr_block               = var.vcn_cidr_block
    vcn_name                     = var.vcn_name
    subnet_cidr_block            = var.subnet_cidr_block
    subnet_display_name          = var.subnet_display_name
    subnet_dns_label             = var.subnet_dns_label
    route_table_name             = var.route_table_name
    IG_name                      = var.IG_name
    dns_zone_name                = var.dns_zone_name
    dns_zone_type                = var.dns_zone_type
    create_vcn                   = var.create_vcn
    exist_vcn_id                 = try(var.create_vcn ? "" : data.oci_core_vcns.existing_vcns.virtual_networks[0].id)
    exist_vcn_dhcp_options_id    = try(var.create_vcn ? "" : data.oci_core_vcns.existing_vcns.virtual_networks[0].default_dhcp_options_id)
}

data "oci_core_vcns" "existing_vcns" {
    compartment_id   = module.oci-identity-managment.compartm_id
    display_name     = var.vcn_display_name
    state            = var.vcn_state
}

resource "null_resource" "ansible_provision" {
   provisioner "local-exec" {
        command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u '${var.ssh_user}' -i '${module.oci-app-instance.public-ip-address},' --private-key ${var.ssh_key_private} -e 'TG_ADMIN=${local.TG_ADMIN} TG_TOKEN=${local.TG_TOKEN} staging=0' ansible/mqtt-server.yml"
   }
}