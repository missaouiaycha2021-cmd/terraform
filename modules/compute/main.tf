resource "aws_instance" "dashboard_az1" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.dashboard_subnet_az1
  security_groups = [var.frontend_sg]
  key_name        = var.key_name
  tags = { Name = "dashboard-az1" }
  user_data = file("${path.module}/user_data.sh")
}
resource "aws_instance" "dashboard_az2" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.dashboard_subnet_az2
  security_groups = [var.frontend_sg]
  key_name        = var.key_name
  tags = { Name = "dashboard-az2" }
  user_data = file("${path.module}/user_data_node.sh")
}
resource "aws_instance" "backend_az1" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.backend_subnet_az1
  security_groups = [var.backend_sg]
  key_name        = var.key_name
  tags = { Name = "backend-az1" }
  user_data = file("${path.module}/user_data_node.sh")
}
resource "aws_instance" "backend_az2" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.backend_subnet_az2
  security_groups = [var.backend_sg]
  key_name        = var.key_name
  tags = { Name = "backend-az2" }
  user_data = file("${path.module}/user_data_node.sh")
}