output "tc_server_db_address" {
  value       = aws_db_instance.teamcity_database.address
  description = "Connect to the database at this endpoint"
}

output "tc_server_db_port" {
  value       = aws_db_instance.teamcity_database.port
  description = "The port the database is listening on"
}
