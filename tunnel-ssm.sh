#!/bin/bash

REGION=$(aws configure get region)
CIDR=$(aws ec2 --output text --query 'Vpcs[*].{CidrBlock:CidrBlock}' describe-vpcs --filters Name=tag:cidr,Values=tunnel)
BASTION_INSTANCE=$(aws ec2 describe-instances --region $REGION --query 'Reservations[*].Instances[*].{IdInstancia:InstanceId}' --filters Name=tag:Name,Values=>

echo "Conectando-se a VPC de região "$REGION
echo "Adicionando a rota "$CIDR
echo "Usando a instancia $BASTION_INSTANCE como Tunnel"
echo ""
echo "Para fechar o Tunnel pressione Ctrl+c"
echo "" 
ssm-tunnel $BASTION_INSTANCE --route $CIDR
