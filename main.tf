terraform {
  required_version = "> 1.2.1"
  # backend "s3" {}
}


# resource "adobecommercecloud_ssh_key" "existing_key" {
#    title = "platformsh"
#    key   = file("~/.ssh/platformsh.pub")
# }

module "cloudbackend" {
  source = "cloudbackend"
  providers = {
    adobecommercecloud = adobecommercecloud.root
   }
  
  api_token = var.api_token
  title = var.title
  environments = var.environments
  storage = var.storage
  mage_composer_username = var.mage_composer_username
  mage_composer_password = var.mage_composer_password
  github_token = var.github_token
}

