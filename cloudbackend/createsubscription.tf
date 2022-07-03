resource "adobecommercecloud_subscription" "new" {
    plan = "magento/starter"
    region = "us-4.magento.cloud"
    title = var.title
    environments = var.environments
    storage = var.storage
    user_licenses = 1
}


# "time_sleep" resource gives necessary window for the subcription to be created to avoid race condition when refering to subcription id in datasources
resource "time_sleep" "wait_5_seconds" {
#   depends_on = [resource.adobecommercecloud_subscription.new]

  create_duration = "5s"
}


data "adobecommercecloud_subscription" "example" {
    id = adobecommercecloud_subscription.new.id
    depends_on = [
        time_sleep.wait_5_seconds
    ]
}

# resource "adobecommercecloud_ssh_key" "existing_key" {
#    title = "platformsh"
#    key   = file("~/.ssh/platformsh.pub")
# }


# resource "adobecommercecloud_project_variable" "composer_auth" {
#   project_id = data.adobecommercecloud_subscription.example.project_id
# #   project_id = "glz6omalw5eai"
#   name = "env:COMPOSER_AUTH"
#   value = templatefile("${path.module}/configs/composer_auth.tftpl", { username = var.mage_composer_username, password = var.mage_composer_password, gh_token = var.github_token })
  
#   is_json = true
#   is_sensitive = true
#   visible_build = true

# }



# locals {
#   project_id = data.adobecommercecloud_subscription.example.project_id
# }


# data "adobecommercecloud_project" "existing_project" {    
#     id = local.project_id
# }

resource "local_file" "services" {
  content = templatefile("${path.module}/configs/services.tftpl",
           { mysql_version = var.mysql_version, 
              mysql_disk_size = var.mysql_disk_size, 
              redis_version = var.redis_version, 
              opensearch_version = var.opensearch_version, 
              opensearch_disksize = var.opensearch_disksize, 
              rabbitmq_version = var.rabbitmq_version, 
              rabbitmq_disksize = var.rabbitmq_disksize
           })
        filename = "${path.module}/configs/services.yaml"     
}


resource "local_file" "composer_auth" {
  content = templatefile("${path.module}/configs/composer_auth.tftpl",
           { username = var.mage_composer_username, 
             password = var.mage_composer_password,
             gh_token = var.github_token             
           })
        filename = "${path.module}/configs/auth.json"     
}



resource "null_resource" "setup_env" {
  triggers = {
    always_run = "${timestamp()}"
  }

 provisioner "local-exec" {

    command = "/bin/bash ../cloudbackend/setup-env.sh"

    environment = {
      DIR = var.title
      PROJECT_ID = data.adobecommercecloud_subscription.example.project_id
     }
  }
}