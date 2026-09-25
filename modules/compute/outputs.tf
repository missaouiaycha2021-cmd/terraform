output "dashboard_ips"  { value = [aws_eip.dashboard.public_ip] }
output "backend_ips"    { value = [aws_instance.backend_az1.private_ip] }
output "monitoring_ip"  { value = aws_eip.monitoring.public_ip }
output "database_ip"    { value = aws_instance.database.private_ip }