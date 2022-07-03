#!/bin/sh

#check if terraform is installed

terraform version
if [ $? != 0 ]; then
   wget -qO - terraform.gpg https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/terraform-archive-keyring.gpg
   sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/terraform-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/terraform.list
   sudo apt update
   sudo apt install terraform=1.2.2
   terraform version
fi    

sed -i "s|{project_name}|magento-cloud-auto-deploy|g" providers.tf
sed -i "s|{branch}|master|g" providers.tf

terraform init
terraform apply -var "api_token=${COMMERCE_CLOUD_TOKEN}" -var "mage_composer_username=${MAGE_COMPOSER_USERNAME}" -var "mage_composer_password=${MAGE_COMPOSER_PASSWORD}" -var "github_token=${GH_TOKEN}" -var "title=magento-cloud-auto-deploy"
