# Launch SLES-HAE of SLES4SAP cluster nodes

# Variables for type of instances to use and number of cluster nodes
# Use with: terraform apply -var instancetype=t2.micro -var ninstances=2

variable "instancetype" {
  type    = string
  default = "r3.8xlarge"
}

variable "hana_os_image" {
  description = "sles4sap AMI image identifier or a pattern used to find the image name (e.g. suse-sles-sap-15-sp1-byos)"
  type        = string
  default     = "suse-sles-sap-15-sp1-byos"
}

variable "hana_os_owner" {
  description = "OS image owner"
  type        = string
  default     = "amazon"
}

variable "hana_data_disk_type" {
  type    = string
  default = "gp2"
}

variable "hana_cluster_vip" {
  description = "IP address used to configure the hana cluster floating IP. It must be in other subnet than the machines!"
  type        = string
  default     = "192.168.1.10"
}

variable "ninstances" {
  type    = string
  default = "2"
}

variable "aws_region" {
  type = string
}

variable "name" {
  description = "hostname, without the domain part"
  type        = string
}

variable "public_key_location" {
  type = string
}

variable "private_key_location" {
  type = string
}

variable "aws_credentials" {
  description = "AWS credentials file path in local machine"
  type        = string
  default     = "~/.aws/credentials"
}

variable "aws_access_key_id" {
  type    = string
  default = ""
}

variable "aws_secret_access_key" {
  type    = string
  default = ""
}

variable "init_type" {
  type    = string
  default = "all"
}

variable "hana_inst_master" {
  type = string
}

variable "hana_inst_folder" {
  type    = string
  default = "/root/hana_inst_media"
}

variable "hana_disk_device" {
  description = "device where to install HANA"
  type        = string
}

variable "hana_fstype" {
  description = "Filesystem type to use for HANA"
  type        = string
  default     = "xfs"
}

variable "iscsi_os_image" {
  description = "sles4sap AMI image identifier or a pattern used to find the image name (e.g. suse-sles-sap-15-sp1-byos)"
  type        = string
  default     = "suse-sles-sap-15-sp1-byos"
}

variable "iscsi_os_owner" {
  description = "OS image owner"
  type        = string
  default     = "amazon"
}

variable "iscsidev" {
  description = "device iscsi for iscsi server"
  type        = string
}

variable "iscsi_disks" {
  description = "number of partitions attach to iscsi server. 0 means `all`."
  default     = 0
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
  type        = string
  default     = ""
}

variable "reg_email" {
  description = "Email used for the registration"
  default     = ""
}

# The module format must follow SUSEConnect convention:
# <module_name>/<product_version>/<architecture>
# Example: Suggested modules for SLES for SAP 15
# - sle-module-basesystem/15/x86_64
# - sle-module-desktop-applications/15/x86_64
# - sle-module-server-applications/15/x86_64
# - sle-ha/15/x86_64 (Need the same regcode as SLES for SAP)
# - sle-module-sap-applications/15/x86_64

variable "reg_additional_modules" {
  description = "Map of the modules to be registered. Module name = Regcode, when needed."
  type        = map(string)
  default     = {}
}

variable "additional_packages" {
  description = "extra packages which should be installed"
  default     = []
}

variable "host_ips" {
  description = "ip addresses to set to the nodes. The first ip must be in 10.0.0.0/24 subnet and the second in 10.0.1.0/24 subnet"
  type        = list(string)
}

# Repository url used to install HA/SAP deployment packages"
# The latest RPM packages can be found at:
# https://download.opensuse.org/repositories/network:/ha-clustering:/Factory/{YOUR OS VERSION}
# Contains the salt formulas rpm packages.
variable "ha_sap_deployment_repo" {
  description = "Repository url used to install HA/SAP deployment packages"
  type        = string
}

variable "scenario_type" {
  description = "Deployed scenario type. Available options: performance-optimized, cost-optimized"
  default     = "performance-optimized"
}

variable "provisioner" {
  description = "Used provisioner option. Available options: salt. Let empty to not use any provisioner"
  default     = "salt"
}

variable "background" {
  description = "Run the provisioner execution in background if set to true finishing terraform execution"
  default     = false
}

# drbd related variables

variable "drbd_enabled" {
  description = "enable the DRBD cluster for nfs"
  default     = false
}

variable "drbd_machine_type" {
  description = "machine type for drbd nodes"
  type        = string
  default     = "t2.xlarge"
}

variable "drbd_os_image" {
  description = "sles4sap AMI image identifier or a pattern used to find the image name (e.g. suse-sles-sap-15-sp1-byos)"
  type        = string
  default     = "suse-sles-sap-15-sp1-byos"
}

variable "drbd_os_owner" {
  description = "OS image owner"
  type        = string
  default     = "amazon"
}

variable "drbd_data_disk_size" {
  description = "drbd data disk size"
  type        = string
  default     = "10"
}

variable "drbd_data_disk_type" {
  description = "drbd data disk type"
  type        = string
  default     = "gp2"
}

variable "drbd_ips" {
  description = "ip addresses to set to the drbd cluster nodes"
  type        = list(string)
  default     = ["10.0.4.11", "10.0.5.12"]
}

variable "drbd_cluster_vip" {
  description = "IP address used to configure the drbd cluster floating IP. It must be in other subnet than the machines!"
  type        = string
  default     = "192.168.1.30"
}

# Netweaver variables

variable "netweaver_enabled" {
  description = "enable SAP Netweaver cluster deployment"
  default     = false
}

variable "netweaver_os_image" {
  description = "sles4sap AMI image identifier or a pattern used to find the image name (e.g. suse-sles-sap-15-sp1-byos)"
  type        = string
  default     = "suse-sles-sap-15-sp1-byos"
}

variable "netweaver_os_owner" {
  description = "OS image owner"
  type        = string
  default     = "amazon"
}

variable "netweaver_instancetype" {
  description = "VM size for the Netweaver machines. Default to r3.8xlarge"
  type        = string
  default     = "r3.8xlarge"
}

variable "netweaver_s3_bucket" {
  description = "S3 bucket where Netwaever installation files are stored"
  type        = string
  default     = ""
}

variable "netweaver_efs_performance_mode" {
  type        = string
  description = "Performance mode of the EFS storage used by Netweaver"
  default     = "generalPurpose"
}

variable "netweaver_ips" {
  description = "ip addresses to set to the netweaver cluster nodes"
  type        = list(string)
  default     = []
}

variable "netweaver_virtual_ips" {
  description = "virtual ip addresses to set to the netweaver cluster nodes"
  type        = list(string)
  default     = []
}

# Monitoring

variable "monitoring_os_image" {
  description = "sles4sap AMI image identifier or a pattern used to find the image name (e.g. suse-sles-sap-15-sp1-byos)"
  type        = string
  default     = "suse-sles-sap-15-sp1-byos"
}

variable "monitoring_os_owner" {
  description = "OS image owner"
  type        = string
  default     = "amazon"
}

# Specific QA variables

variable "qa_mode" {
  description = "define qa mode (Disable extra packages outside images)"
  type        = bool
  default     = false
}

variable "hwcct" {
  description = "Execute HANA Hardware Configuration Check Tool to bench filesystems"
  type        = bool
  default     = false
}
