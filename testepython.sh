#!/bin/bash

echo "Digite o nome da instância (ou parte do nome): "
read instance_name

# Busca por instâncias que contém ou são iguais ao nome informado pelo usuário
instances=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$instance_name*" --query "Reservations[*].Instances[*].[InstanceId, Tags[?Key=='Name'].Value | [0]]" --output text | head -n 15)

if [[ -z "$instances" ]]; then
  echo "Nenhuma instância encontrada com o nome '$instance_name'"
  exit 1
fi

# Cria um menu com as instâncias encontradas
echo "Selecione uma instância para iniciar uma sessão do SSM:"
PS3="Digite o número da instância: "
select instance in $instances; do
#  if [[ -n "$instance" ]]; then
    echo $instance
    #instance_name=$(echo $instance | awk '{print $2}')
#    echo "Iniciando sessão do SSM na instância '$instance_name' ($instance_id)..."
#    aws ssm start-session --target $instance_id
#    break
#  else
#    echo "Opção inválida. Tente novamente."
#  fi
done
