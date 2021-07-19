resource "aws_spot_instance_request" "server" {
  ami                         = data.susepubliccloud_image_ids.sles.ids[0]
  associate_public_ip_address = true
  count                       = var.server_spot_instances_count
  instance_type               = var.server_type
  key_name                    = aws_key_pair.kube.key_name
  source_dest_check           = false
  subnet_id                   = aws_subnet.public.id
  user_data                   = data.template_cloudinit_config.cfg.rendered
  iam_instance_profile        = length(var.iam_profile_server) == 0 ? local.aws_iam_instance_profile_server_terraform : var.iam_profile_server

  #spot instance details
  wait_for_fulfillment = true
  spot_type            ="one-time"

  depends_on = [
    aws_iam_instance_profile.server,
  ]

  tags = merge(
    local.tags,
    {
      "Name"  = "${var.stack_name}-server-${count.index}"
      "Class" = "Instance"
    },
  )

  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.common.id,
    aws_security_group.server.id,
  ]

  lifecycle {
    create_before_destroy = true

    ignore_changes = [ami]
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }
}
