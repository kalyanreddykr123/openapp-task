#!/bin/bash
#Update you aws keys below
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY_ID=""

if [ $1 == apply ]
then
terraform init
terraform apply -auto-approve
elif [ $1 == destroy ]
then
terraform init
terraform destroy -auto-approve
else
echo "PLease provide option apply or destroy ex: sh auto_script.sh apply"
fi
