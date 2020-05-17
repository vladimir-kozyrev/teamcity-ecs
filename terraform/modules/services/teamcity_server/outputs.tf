output "tc_server_public_ip" {
  value       = aws_instance.teamcity_server.public_ip
  description = "Connect to the server via SSH at this endpoint"
}

output "alb_dns_name" {
  value       = module.teamcity_server_alb.this_lb_dns_name
  description = "The DNS name of the load balancer"
}
