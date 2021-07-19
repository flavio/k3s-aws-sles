# This security group is deliberately left empty,
# it's applied only to agent nodes.
#
# This security group is the only one with the
# `kubernetes.io/cluster/<cluster name>` tag, that makes it discoverable by the
# AWS CPI controller.
# As a result of that, this is going to be the security group the CPI will
# alter to add the rules needed to access the worker nodes from the AWS
# resources dynamically provisioned by the CPI (eg: load balancers).
resource "aws_security_group" "agent" {
  description = "security group rules for agent node"
  name        = "${var.stack_name}-agent"
  vpc_id      = aws_vpc.platform.id

  tags = merge(
    local.tags,
    {
      "Name"  = "${var.stack_name}-agent"
      "Class" = "SecurityGroup"
    },
  )
}

