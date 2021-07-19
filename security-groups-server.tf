resource "aws_security_group" "server" {
  description = "security rules for server nodes"
  name        = "${var.stack_name}-server"
  vpc_id      = aws_vpc.platform.id

  tags = merge(
    local.basic_tags,
    {
      "Name"  = "${var.stack_name}-server"
      "Class" = "SecurityGroup"
    },
  )

  # etcd - internal
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "etcd"
  }

  # api-server - everywhere
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "kubernetes api-server"
  }
}

