#!/bin/bash
set -e

ENV=$1   # e.g. dev, prod
DIR=$(pwd)

# Terraform
cd $DIR/terraform
terraform init
terraform workspace select $ENV || terraform workspace new $ENV
terraform apply -var-file="envs/$ENV/terraform.tfvars" -auto-approve

DB_HOST=$(terraform output -raw db_endpoint)

# Helm
cd $DIR/helm
helm dependency update

# Patch values file with DB hostname
cp values-$ENV.yaml values-$ENV-temp.yaml
yq e -i ".env.DATABASE_HOST = \"$DB_HOST\"" values-$ENV-temp.yaml

helm upgrade --install myapp-release . -f values-$ENV-temp.yaml

rm values-$ENV-temp.yaml

