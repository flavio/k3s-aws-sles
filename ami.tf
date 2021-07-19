terraform {
  required_providers {
    susepubliccloud = {
      source  = "SUSE/susepubliccloud"
      version = "0.0.5"
    }
  }
}

data "susepubliccloud_image_ids" "sles" {
  cloud  = "amazon"
  region = data.aws_region.current.name
  state  = "active"

  name_regex = format(
    "suse-sles-15-sp3-v(\\d)*-hvm-ssd-%s",
    var.enable_arm64 ? "arm64" :"x86_64")
}

data "aws_region" "current" {}
