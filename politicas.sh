#!/bin/bash

# Definir o nome do ambiente
environment_name="portal-1"

# Obter o ID do ambiente usando o ElasticBeanstalk CLI
environment_id=$(aws elasticbeanstalk describe-environments \
  --environment-names $environment_name \
  --query 'Environments[0].EnvironmentId' \
  --output text)

# Obter o ARN do perfil de função do EC2 para o ambiente
instance_profile_arn=$(aws elasticbeanstalk describe-environment-resources \
  --environment-id $environment_id \
  --query 'EnvironmentResources.InstancesProfile' \
  --output text)

# Obter o nome da política do IAM para o perfil de função do EC2
policy_name=$(aws iam get-instance-profile \
  --instance-profile-name $instance_profile_arn \
  --query 'InstanceProfile.Roles[0].PolicyNames[0]' \
  --output text)

# Obter a versão da política do IAM para o perfil de função do EC2
policy_version=$(aws iam get-policy \
  --policy-arn arn:aws:iam::aws:policy/$policy_name \
  --query 'Policy.DefaultVersionId' \
  --output text)

# Obter a política do IAM para o perfil de função do EC2
policy_document=$(aws iam get-policy-version \
  --policy-arn arn:aws:iam::aws:policy/$policy_name \
  --version-id $policy_version \
  --query 'PolicyVersion.Document' \
  --output text)

# Mostrar a política do IAM para o perfil de função do EC2
echo "$policy_document"
