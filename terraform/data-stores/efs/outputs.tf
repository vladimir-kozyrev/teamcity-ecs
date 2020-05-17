output "teamcity_efs_dns_name" {
  value       = aws_efs_file_system.teamcity_server.dns_name
  description = "The DNS name of TeamCity EFS"
}
