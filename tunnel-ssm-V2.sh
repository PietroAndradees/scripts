#!/bin/bash
#REGION=us-east-1
pkill -9 sshuttle
REGION=$(aws configure get region)
CIDR="10.64.0.0/16 192.168.248.0/21 10.110.0.0/21"
REDE_LOCAL="XXX.XXX.XXX.XXX/XX" #SUA REDE LOCAL
BASTION_INSTANCE=i-05360df5b9a5eb8ef #34.226.74.203
NOME="NOME.SOBRENOME" #O mesmo prefixo do email coorporativo
TRANSPARENT_PROXY="0.0.0.0:0"
DOCKER_GW="0.0.0.0"
REDE_DOCKER="172.17.0.0/24"
echo "Conectando-se a VPC de região "$REGION
echo "Adicionando a rota $CIDR para VPC e para o Docker $REDE_DOCKER" 
echo "Usando a instancia $BASTION_INSTANCE como Tunnel"
echo ""
echo "Para fechar o Tunnel pressione Ctrl+c"
echo "" 
sshuttle --dns -N -r $NOME@$BASTION_INSTANCE $CIDR &ç
sleep 0.5
sshuttle -l $DOCKER_GW -r $NOME@$BASTION_INSTANCE $CIDR -x $REDE_DOCKER &

#sshuttle -l $TRANSPARENT_PROXY --disable-ipv6 --dns -N -r $NOME@$BASTION_INSTANCE $CIDR --ssh-cmd 'ssh -i ~/.ssh/\$NOME'
#sshuttle --dns -N -r ec2-user@i-05360df5b9a5eb8ef 10.64.0.0/16 10.32.0.0/16
