output "teamcity_server_ssh_endpoint" {
  value       = module.teamcity_server.tc_server_public_ip
  description = "Connect to the server via SSH at this endpoint"
}

output "teamcity_server_http_endpoint" {
  value       = module.teamcity_server.alb_dns_name
  description = "Connect to the server via HTTP at this endpoint"
}
