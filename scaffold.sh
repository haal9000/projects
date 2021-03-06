#!/bin/sh

#check if terraform is installed


# wget -qO - terraform.gpg https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/terraform-archive-keyring.gpg
# sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/terraform-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/terraform.list
# sudo apt update
# sudo apt install terraform=1.2.2
apt remove terraform
wget https://releases.hashicorp.com/terraform/1.2.2/terraform_1.2.2_linux_amd64.zip
# wget https://releases.hashicorp.com/terraform/1.2.4/terraform_1.2.4_linux_arm64.zip
unzip terraform_1.2.2_linux_amd64.zip
# unzip terraform_1.2.4_linux_arm64.zip
mv terraform /usr/bin
terraform version

sed -i "s|{project_name}|magento-cloud-auto-deploy|g" providers.tf
sed -i "s|{branch}|master|g" providers.tf

echo $PWD

apt-get update
apt-get install awscli -y

aws --version



# mkdir -p ~/.terraform.d/plugins/git.corp.adobe.com/jomoore/commerce-cloud/0.1/linux_amd64
# aws s3 cp s3://commerce-cloud-projects/linux_amd64/terraform-provider-commerce-cloud ~/.terraform.d/plugins/git.corp.adobe.com/jomoore/commerce-cloud/0.1/linux_amd64
# chmod +x ~/.terraform.d/plugins/git.corp.adobe.com/jomoore/commerce-cloud/0.1/linux_amd64/terraform-provider-commerce-cloud
# ls -al ~/.terraform.d/plugins/git.corp.adobe.com/jomoore/commerce-cloud/0.1/linux_amd64/

mkdir -p ~/.terraform.d/plugins/git.corp.adobe.com/jomoore/commerce-cloud/0.1/x86-64
aws s3 cp s3://commerce-cloud-projects/x86-64/terraform-provider-commerce-cloud ~/.terraform.d/plugins/git.corp.adobe.com/jomoore/commerce-cloud/0.1/x86-64
chmod +x ~/.terraform.d/plugins/git.corp.adobe.com/jomoore/commerce-cloud/0.1/x86-64/terraform-provider-commerce-cloud
ls -al ~/.terraform.d/plugins/git.corp.adobe.com/jomoore/commerce-cloud/0.1/x86-64/

# cat providers.tf
terraform init
terraform apply -var "api_token=${COMMERCE_CLOUD_TOKEN}" -var "mage_composer_username=${MAGE_COMPOSER_USERNAME}" -var "mage_composer_password=${MAGE_COMPOSER_PASSWORD}" -var "github_token=${GH_TOKEN}" -var "title=magento-cloud-auto-deploy"
