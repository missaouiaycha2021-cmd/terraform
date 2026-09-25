# PUBLIC - dashboard
resource "aws_instance" "dashboard_az1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.dashboard_subnet_az1
  security_groups             = [var.frontend_sg]
  key_name                    = var.key_name
  iam_instance_profile        = "LabInstanceProfile"
  monitoring                  = true
  associate_public_ip_address = true   # ← publique
  tags                        = { Name = "dashboard-az1" }
  user_data                   = file("${path.module}/user_data_node.sh")
}

# PRIVÉ - backend
resource "aws_instance" "backend_az1" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.backend_subnet_az1
  security_groups             = [var.backend_sg]
  key_name                    = var.key_name
  iam_instance_profile        = "LabInstanceProfile"
  monitoring                  = true
  associate_public_ip_address = false  # ← privée
  tags                        = { Name = "backend-az1" }
  user_data                   = file("${path.module}/user_data_node.sh")
}

# PRIVÉ - database
resource "aws_instance" "database" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.db_subnet_az1
  security_groups             = [var.db_sg]
  key_name                    = var.key_name
  iam_instance_profile        = "LabInstanceProfile"
  monitoring                  = true
  associate_public_ip_address = false  # ← privée
  tags                        = { Name = "database" }
  user_data                   = file("${path.module}/user_data_mongo.sh")
}

# PUBLIC - monitoring
resource "aws_instance" "monitoring" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.dashboard_subnet_az1
  security_groups             = [var.monitoring_sg]
  key_name                    = var.key_name
  iam_instance_profile        = "LabInstanceProfile"
  monitoring                  = true
  associate_public_ip_address = true   # ← publique
  tags                        = { Name = "monitoring" }
  user_data                   = file("${path.module}/user_data.sh")
}

# EIP seulement pour les instances publiques
resource "aws_eip" "dashboard" {
  instance = aws_instance.dashboard_az1.id
  domain   = "vpc"
}

resource "aws_eip" "monitoring" {
  instance = aws_instance.monitoring.id
  domain   = "vpc"
}