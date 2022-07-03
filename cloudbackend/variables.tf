variable "api_token" {
  description = "Access token used to configure the provider"
  type        = string
}

variable "title" {
  description = "Name of the project"
  type    = string
}

variable "environments" {
  description = "Maximum number of environments for the project"
  type    = number
  default = 2
}

variable "storage" {
  description = "Storage (in MB) for all the environments"
  type    = number
}

variable "mysql_version" {
  type = string
  default = "10.4"  
}

variable "mysql_disk_size" {
  type = string
  default = "5120"  
}

variable "redis_version" {
  type = string
  default = "6.2"
}

variable "opensearch_version" {
  type = string
  default = "1.2"
}

variable "opensearch_disksize" {
  type = string
  default = "1024"
}

variable "rabbitmq_version" {
  type = string
  default = "3.9"
}

variable "rabbitmq_disksize" {
  type = string
  default = "1024"
}

variable "mage_composer_username" {
  description = "COMPOSER_AUTH http-basic username for repo.magento.com"
  type = string
}

variable "mage_composer_password" {
  description = "COMPOSER_AUTH http-basic password for repo.magento.com"
  type = string
}

variable "github_token" {
  description = "COMPOSER_AUTH token to download packages from github"
  type = string
}