output "dashboard_subnet_az1" { value = aws_subnet.dashboard_az1.id }
output "dashboard_subnet_az2" { value = aws_subnet.dashboard_az2.id }
output "backend_subnet_az1"   { value = aws_subnet.backend_az1.id }
output "backend_subnet_az2"   { value = aws_subnet.backend_az2.id }
output "db_subnet_az1"        { value = aws_subnet.db_az1.id }
output "db_subnet_az2"        { value = aws_subnet.db_az2.id }
output "vpc_id"               { value = aws_vpc.main.id }