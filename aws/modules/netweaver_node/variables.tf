variable "netweaver_count" {
  type    = string
  default = "4"
}

variable "instancetype" {
  type    = string
  default = "r3.8xlarge"
}

variable "name" {
  description = "prefix of the machines names"
  type        = string
}

variable "aws_region" {
  type = string
}

variable "availability_zones" {
  type        = list(string)
  description = "Used availability zones"
}

variable "os_image" {
  description = "sles4sap AMI image identifier or a pattern used to find the image name (e.g. suse-sles-sap-15-sp1-byos)"
  type        = string
}

variable "os_owner" {
  description = "OS image owner"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "Id of the vpc used for this deployment"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block of the used vpc"
}

variable "key_name" {
  type        = string
  description = "AWS key pair name"
}

variable "security_group_id" {
  type        = string
  description = "Security group id"
}

variable "route_table_id" {
  type        = string
  description = "Route table id"
}

variable "efs_performance_mode" {
  type        = string
  description = "Performance mode of the EFS storage"
  default     = "generalPurpose"
}

variable "aws_credentials" {
  description = "AWS credentials file path in local machine"
  type        = string
  default     = "~/.aws/credentials"
}

variable "aws_access_key_id" {
  type    = string
}

variable "aws_secret_access_key" {
  type    = string
}

variable "s3_bucket" {
  description = "S3 bucket where Netwaever installation files are stored"
  type    = string
}

variable "hana_ip" {
  description = "IP address of the HANA database. If the database is clustered, use the cluster virtual ip address"
  type        = string
  default     = "192.168.1.10"
}

variable "host_ips" {
  description = "ip addresses of the machines. Remember that each of the machines is in a different subnet"
  type        = list(string)
  default     = ["10.0.2.7", "10.0.3.8", "10.0.2.9", "10.0.3.10"]
}

variable "virtual_host_ips" {
  description = "virtual ip addresses to set to the nodes. They must have a different IP range than the used range in the vpc"
  type        = list(string)
  default     = ["192.168.1.20", "192.168.1.21", "192.168.1.22", "192.168.1.23"]
}

variable "ascs_instance_number" {
  description = "ASCS instance number"
  type        = string
  default     = "00"
}

variable "ers_instance_number" {
  description = "ERS instance number"
  type        = string
  default     = "10"
}

variable "pas_instance_number" {
  description = "PAS instance number"
  type        = string
  default     = "01"
}

variable "aas_instance_number" {
  description = "AAS instance number"
  type        = string
  default     = "02"
}

variable "network_domain" {
  type    = string
  default = "tf.local"
}

variable "public_key_location" {
  type = string
}

variable "private_key_location" {
  type = string
}

variable "iscsi_srv_ip" {
  description = "iscsi server address"
  type        = string
}

variable "cluster_ssh_pub" {
  description = "path for the public key needed by the cluster"
  type        = string
}

variable "cluster_ssh_key" {
  description = "path for the private key needed by the cluster"
  type        = string
}

variable "reg_code" {
  description = "If informed, register the product using SUSEConnect"
  default     = ""
}

variable "reg_email" {
  description = "Email used for the registration"
  default     = ""
}

variable "reg_additional_modules" {
  description = "Map of the modules to be registered. Module name = Regcode, when needed."
  type        = map(string)
  default     = {}
}

variable "ha_sap_deployment_repo" {
  description = "Repository url used to install HA/SAP deployment packages"
  type        = string
}

variable "devel_mode" {
  description = "Whether or not to install the HA/SAP packages from the `ha_sap_deployment_repo`"
  default     = false
}

variable "qa_mode" {
  description = "Whether or not to install the HA/SAP packages from the `ha_sap_deployment_repo`"
  default     = false
}

variable "provisioner" {
  description = "Used provisioner option. Available options: salt. Let empty to not use any provisioner"
  default     = "salt"
}

variable "background" {
  description = "Run the provisioner execution in background if set to true finishing terraform execution"
  default     = false
}

variable "monitoring_enabled" {
  description = "enable the host to be monitored by exporters, e.g node_exporter"
  default     = false
}
