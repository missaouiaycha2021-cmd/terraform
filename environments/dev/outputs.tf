output "frontend_ips" {
  value = module.compute.dashboard_ips
}
output "backend_ips" {
  value = module.compute.backend_ips
}
output "loadbalancer_dns" {
  value = module.loadbalancer.lb_dns_name
}
output "monitoring_ip" {
  value = module.compute.monitoring_ip
}
output "database_ip" {
  value = module.compute.database_ip
}