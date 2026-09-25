terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

module "network" {
  source               = "../../modules/network"
  vpc_cidr             = var.vpc_cidr
  az1                  = var.az1
  az2                  = var.az2
  dashboard_subnet_az1 = var.dashboard_subnet_az1
  dashboard_subnet_az2 = var.dashboard_subnet_az2
  backend_subnet_az1   = var.backend_subnet_az1
  backend_subnet_az2   = var.backend_subnet_az2
  db_subnet_az1        = var.db_subnet_az1
  db_subnet_az2        = var.db_subnet_az2
}

module "security" {
  source = "../../modules/security"
  vpc_id = module.network.vpc_id
}

module "compute" {
  source               = "../../modules/compute"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  dashboard_subnet_az1 = module.network.dashboard_subnet_az1
  dashboard_subnet_az2 = module.network.dashboard_subnet_az2
  backend_subnet_az1   = module.network.backend_subnet_az1
  backend_subnet_az2   = module.network.backend_subnet_az2
  frontend_sg          = module.security.frontend_sg
  backend_sg           = module.security.backend_sg
  key_name             = var.key_name
  monitoring_sg        = module.security.monitoring_sg
  db_subnet_az1        = module.network.db_subnet_az1
  db_sg                = module.security.db_sg
}

module "loadbalancer" {
  source               = "../../modules/loadbalancer"
  dashboard_subnet_az1 = module.network.dashboard_subnet_az1
  dashboard_subnet_az2 = module.network.dashboard_subnet_az2
  vpc_id               = module.network.vpc_id
  frontend_sg          = module.security.frontend_sg
}

module "monitoring" {
  source = "../../modules/monitoring"
}