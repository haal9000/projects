provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

terraform {
  required_providers {
    adobecommercecloud = {
      version = "0.1"
      # Terraform looks for the provider in the below path on the machine when the provider is initialized
      source  = "git.corp.adobe.com/jomoore/commerce-cloud"
    }
  }
  backend "s3" {
    bucket         = "commerce-cloud-projects"
    key            = "terraform/state/{project_name}/{branch}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "commercecloud-projects"
    profile        = "default"
  }
}

provider "adobecommercecloud" {
  api_token = var.api_token
  alias  = "root"
}