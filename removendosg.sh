#!/bin/bash

# Define o filtro para listar os Security Groups
FILTER="Name=group-name,Values=awseb* Name=ip-permission.from-port,Values=22 Name=ip-permission.to-port,Values=22"

# Lista os Security Groups que atendem o filtro
instance_ids=$(aws ec2 describe-security-groups --filters $FILTER --query "SecurityGroups[*].GroupId" --output text)
for id in $instance_ids
do
    echo "Removendo acesso SSH do Security Group: $id"
    aws ec2 revoke-security-group-ingress --group-id $id --protocol tcp --port 22 --cidr 0.0.0.0/0
done
