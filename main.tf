#
# Ensure Secret exists
#
data "aws_secretsmanager_secret" "password" {
  name = var.aws_secretmanager_secret_id
}

#
# Find BIG-IP AMI
#
data "aws_ami" "f5_ami" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["${var.f5_ami_search_name}"]
  }
}

# 
# Create Management Network Interfaces
#
resource "aws_network_interface" "mgmt" {
  count           = length(var.vpc_mgmt_subnet_ids)
  subnet_id       = var.vpc_mgmt_subnet_ids[count.index]
  security_groups = var.mgmt_subnet_security_group_ids
}

#
# add an elastic IP to the BIG-IP management interface
#
resource "aws_eip" "mgmt" {
  count             = var.mgmt_eip ? length(var.vpc_mgmt_subnet_ids) : 0
  network_interface = aws_network_interface.mgmt[count.index].id
  vpc               = true
}

# 
# Create Private Network Interfaces
#
resource "aws_network_interface" "private" {
  count           = length(var.vpc_private_subnet_ids)
  subnet_id       = var.vpc_private_subnet_ids[count.index]
  security_groups = var.private_subnet_security_group_ids
}

#
# Deploy BIG-IQ
#
resource "aws_instance" "f5_bigiq" {
  # determine the number of BIG-IPs to deploy
  count                = var.f5_instance_count
  instance_type        = var.ec2_instance_type
  ami                  = data.aws_ami.f5_ami.id
  iam_instance_profile = aws_iam_instance_profile.bigiq_profile.name

  key_name = var.ec2_key_name

  root_block_device {
    delete_on_termination = true
  }

  # set the mgmt interface 
  dynamic "network_interface" {
    for_each = toset([aws_network_interface.mgmt[count.index].id])

    content {
      network_interface_id = network_interface.value
      device_index         = 0
    }
  }

  # set the private interface only if an interface is defined
  dynamic "network_interface" {
    for_each = length(aws_network_interface.private) > count.index ? toset([aws_network_interface.private[count.index].id]) : toset([])

    content {
      network_interface_id = network_interface.value
      device_index         = 2
    }
  }

  # build user_data file from template
  user_data = templatefile(
    "${path.module}/f5_onboard.tmpl",
    {
      libs_dir    = var.libs_dir,
      onboard_log = var.onboard_log,
      secret_id   = var.aws_secretmanager_secret_id
    }
  )

  depends_on = [aws_eip.mgmt]

  tags = {
    Name = format("%s-%d", var.prefix, count.index)
  }
}
