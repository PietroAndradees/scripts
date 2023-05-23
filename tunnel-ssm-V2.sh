#!/bin/bash
#REGION=us-east-1
REGION=$(aws configure get region)
CIDR="10.64.0.0/16 192.168.0.0/16"
BASTION_INSTANCE="i-05360df5b9a5eb8ef" #34.226.74.203
TRANSPARENT_PROXY="0.0.0.0"
echo "Conectando-se a VPC de região "$REGION
echo "Adicionando a rota "$CIDR
echo "Usando a instancia $BASTION_INSTANCE como Tunnel"
echo ""
echo "Para fechar o Tunnel pressione Ctrl+c"
echo "" 
sshuttle -l $TRANSPARENT_PROXY --dns -N -r $NOME@$BASTION_INSTANCE $CIDR
#sshuttle -l $TRANSPARENT_PROXY --dns -N -r $NOME@$BASTION_INSTANCE $CIDR --ssh-cmd 'ssh -i ~/.ssh/\$NOME'