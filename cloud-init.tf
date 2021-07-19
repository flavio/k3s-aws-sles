data "template_cloudinit_config" "cfg" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = templatefile("cloud-init.yaml.tpl",
                    {
                      authorized_keys = join("\n", formatlist("  - %s", var.authorized_keys)),
                    })
  }
}
