output "server_nodes_public_ip" {
  value = merge(
            zipmap(aws_instance.server.*.id, aws_instance.server.*.public_ip),
            zipmap(aws_spot_instance_request.server.*.id, aws_spot_instance_request.server.*.public_ip)
          )
}

output "server_nodes_internal_fqdn" {
  value = merge(
    zipmap(aws_instance.server.*.id, aws_instance.server.*.private_dns),
    zipmap(aws_spot_instance_request.server.*.id, aws_spot_instance_request.server.*.private_dns)
  )
}

output "agent_nodes_internal_fqdn" {
  value = merge(
    zipmap(aws_instance.agent.*.id, aws_instance.agent.*.private_dns),
    zipmap(aws_spot_instance_request.agent.*.id, aws_spot_instance_request.agent.*.private_dns)
  )
}
