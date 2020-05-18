output "tc_server_instance_profile" {
  value       = aws_iam_instance_profile.teamcity_server.name
  description = "The port the database is listening on"
}
