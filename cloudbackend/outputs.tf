# internal resource id
output "ID" {
  value = data.adobecommercecloud_subscription.example.id
}

output "project_id" {
  value = data.adobecommercecloud_subscription.example.project_id
}


output "services" {
  value = templatefile("${path.module}/configs/services.tftpl", 
  {mysql_version = var.mysql_version, 
  mysql_disk_size = var.mysql_disk_size, 
  redis_version = var.redis_version, 
  opensearch_version = var.opensearch_version, 
  opensearch_disksize = var.opensearch_disksize, 
  rabbitmq_version = var.rabbitmq_version, 
  rabbitmq_disksize = var.rabbitmq_disksize} 
  )
}


# output "project_repository" {
#   value = data.adobecommercecloud_project.existing_project.repository_url
# }
