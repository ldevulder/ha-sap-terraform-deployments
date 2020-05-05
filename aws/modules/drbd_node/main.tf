# drbd deployment in AWS to host a HA NFS share

# Network resources: subnets, routes, etc
resource "aws_subnet" "drbd-subnet" {
  count              = var.drbd_count
  vpc_id             = var.vpc_id
  cidr_block         = cidrsubnet(var.vpc_cidr_block, 8, count.index+4) # +4 is done to don't conflict with hana and netweaver subnets addresses
  availability_zone  = element(var.availability_zones, count.index)

  tags = {
    Name      = "${terraform.workspace}-drbd-subnet-${count.index + 1}"
    Workspace = terraform.workspace
  }
}

resource "aws_route_table_association" "drbd-subnet-route-association" {
  count          = var.drbd_count
  subnet_id      = element(aws_subnet.drbd-subnet.*.id, count.index)
  route_table_id = var.route_table_id
}

resource "aws_route" "drbd-cluster-vip" {
  count                  = var.drbd_count > 0 ? 1 : 0
  route_table_id         = var.route_table_id
  destination_cidr_block = "${var.drbd_cluster_vip}/32"
  instance_id            = aws_instance.drbd.0.id
}

module "sap_cluster_policies" {
  enabled            = var.drbd_count > 0 ? true : false
  source             = "../../modules/sap_cluster_policies"
  name               = var.name
  aws_region         = var.aws_region
  cluster_instances  = aws_instance.drbd.*.id
  route_table_id     = var.route_table_id
}

resource "aws_instance" "drbd" {
  count                       = var.drbd_count
  ami                         = var.drbd_os_image[var.aws_region]
  instance_type               = var.drbd_machine_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = element(aws_subnet.drbd-subnet.*.id, count.index)
  private_ip                  = element(var.host_ips, count.index)
  security_groups             = [var.security_group_id]
  availability_zone           = element(var.availability_zones, count.index)
  source_dest_check           = false
  iam_instance_profile        = module.sap_cluster_policies.cluster_profile_name[0]

  root_block_device {
    volume_type = "gp2"
    volume_size = "60"
  }

  ebs_block_device {
    volume_type = var.drbd_data_disk_type
    volume_size = var.drbd_data_disk_size
    device_name = "/dev/xvdd"
  }

  volume_tags = {
    Name = "${terraform.workspace}-${var.name}0${count.index + 1}"
  }

  tags = {
    Name         = "${terraform.workspace} - ${var.name}0${count.index + 1}"
    Workspace    = terraform.workspace
    Cluster      = "${var.name}0${count.index + 1}"
  }
}
