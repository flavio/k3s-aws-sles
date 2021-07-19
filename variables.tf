variable "aws_region" {
  type        = string
  description = "AWS region to be used"
}

variable "stack_name" {
  default     = "k3s"
  description = "identifier to make all your resources unique and avoid clashes with other users of this terraform project"
}

variable "authorized_keys" {
  type        = list(string)
  default     = []
  description = "ssh keys to inject into all the nodes. First key will be used for creating a keypair."
}

variable "public_subnet" {
  type        = string
  description = "CIDR blocks for each public subnet of vpc"
  default     = "10.1.1.0/24"
}

variable "private_subnet" {
  type        = string
  description = "Private subnet of vpc"
  default     = "10.1.4.0/24"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIRD blocks for vpc"
  default     = "10.1.0.0/16"
}

variable "server_type" {
  default     = "tg4.large"
  description = "EC2 instance type to be used for server nodes"
}

variable "server_reserved_instances_count" {
  default     = 0
  description = "Number of server nodes allocated using EC2 reserved instances"
}

variable "server_spot_instances_count" {
  default     = 1
  description = "Number of server nodes allocated using EC2 sport instances"
}

variable "agent_type" {
  default     = "tg4.large"
  description = "EC2 instance type to be used for agent nodes"
}

variable "agent_reserved_instances_count" {
  default     = 0
  description = "Number of agent nodes allocated using EC2 reserved instances"
}

variable "agent_spot_instances_count" {
  default     = 0
  description = "Number of agent nodes allocated using EC2 sport instances"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Extra tags used for the AWS resources created"
}

variable "iam_profile_server" {
  default     = ""
  description = "IAM profile associated with the server nodes"
}

variable "iam_profile_agent" {
  default     = ""
  description = "IAM profile associated with the agent nodes"
}

variable "peer_vpc_ids" {
  type        = list(string)
  default     = []
  description = "IDs of a VPCs to connect to via a peering connection"
}

variable "availability_zones_filter" {
  type = object({
    name   = string
    values = list(string)
  })
  default = {
    name   = "zone-name"
    values = ["*"]
  }
  description = "Filter Availability Zones"
}

variable "create_resource_group" {
  type        = bool
  default     = true
  description = "Create AWS Resource Group"
}

variable "enable_arm64" {
  type        = bool
  default     = false
  description = "Enable usage of ARM64 instances. Note well: ensure the server_type and agent_type instances are ARM64"
}
