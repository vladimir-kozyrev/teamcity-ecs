output "teamcity_efs_dns_name" {
  value       = aws_efs_file_system.teamcity_server.dns_name
  description = "The DNS name of TeamCity EFS"
}

output "teamcity_efs_id" {
  value       = aws_efs_file_system.teamcity_server.id
  description = "The ID of TeamCity EFS"
}

output "teamcity_efs_sg_id" {
  value       = aws_security_group.efs.id
  description = "The ID of TeamCity EFS security group"
}
