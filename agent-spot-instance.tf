resource "aws_spot_instance_request" "agent" {
  ami                         = data.susepubliccloud_image_ids.sles.ids[0]
  associate_public_ip_address = true
  count                       = var.agent_spot_instances_count
  instance_type               = var.agent_type
  key_name                    = aws_key_pair.kube.key_name
  source_dest_check           = false
  subnet_id                   = aws_subnet.public.id
  user_data                   = data.template_cloudinit_config.cfg.rendered
  iam_instance_profile        = length(var.iam_profile_agent) == 0 ? local.aws_iam_instance_profile_agent_terraform : var.iam_profile_agent

  #spot instance details
  wait_for_fulfillment = true
  spot_type            ="one-time"

  depends_on = [
    aws_iam_instance_profile.agent,
  ]

  tags = merge(
    local.tags,
    {
      "Name"  = "${var.stack_name}-agent-${count.index}"
      "Class" = "Instance"
    },
  )

  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.common.id,
    aws_security_group.agent.id,
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
