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
  default = 3
}

variable "storage" {
  description = "Storage (in MB) for all the environments"
  type    = number
  default = 51200
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
