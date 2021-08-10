ssh_key_public = "~/ya_rsa.pub"

ssh_key_private = "~/ya_rsa"

region = "eu-frankfurt-1" 

image_id = {
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaakdtauwupkvi54552qmli3ozzj5zdwlhdfzcluphhyawzv7tqeu7q"
  }

compartment_name = "MQTT"

instance_name = "MQTT Server"

vnic_name = "MQTT VNIC"

assign_public_ip = true  

hostname_label = "mqtt-server"

ssh_user = "ubuntu"

remote_exec_command = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

app_tags = {
      "app" = "mqtt"
    }

vcn_dns_label = "internal"  

vcn_cidr_block = "172.16.0.0/20"

vcn_name = "MQTT VCN"

subnet_cidr_block = "172.16.0.0/24"

subnet_display_name = "MQTT subnet"

subnet_dns_label = "mqtt"

route_table_name = "MQTT Access"

IG_name = "MQTT IG"

dns_zone_name = "rand-mqtt.tk"

dns_zone_type = "PRIMARY"

security_list_name = "MQTT security list"

egress_rule = [{"protocol": "6", "destination": "0.0.0.0/0"},]

tcp_ingress_rule = [{"protocol": "6", "source": "0.0.0.0/0", "description": "Allow ssh", "port": "22"}, 
                    {"protocol": "6", "source": "0.0.0.0/0", "description": "Allow http", "port": "80"},
                    {"protocol": "6", "source": "0.0.0.0/0", "description": "Allow https", "port": "443"},
                    {"protocol": "6", "source": "0.0.0.0/0", "description": "Allow mqtt", "port": "1883"},
                    {"protocol": "6", "source": "0.0.0.0/0", "description": "Allow mqtt", "port": "8883"},
                    {"protocol": "6", "source": "0.0.0.0/0", "description": "Allow mqtt websocket", "port": "15675"},
                    {"protocol": "6", "source": "0.0.0.0/0", "description": "Allow TLS mqtt websocket", "port": "15676"}]

create_vcn = true

create_dns = false

create_dns_zone = false

create_dns_record = false

domain_record = [{ "domain_name" : "rand-mqtt.tk", "dns_record_type" : "A", "ttl" : "3600" }]

reserve_public_ip = false
