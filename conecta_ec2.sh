#!/bin/bash

# Lista as instâncias EC2 com base no nome informado pelo usuário
echo ""
read -p "Digite o nome da instância EC2: " instance_name
#instances=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$instance_name" --query "Reservations[].Instances[].{ID:InstanceId, Name:Tags[?Key=='Name'].Value | [0]}" --output text)
instances=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$instance_name*" --query "Reservations[*].Instances[*].[InstanceId, Tags[?Key=='Name'].Value | [0]]" --output text | head -n 20)

# Verifica se foram encontradas instâncias com o nome informado
if [[ -z "$instances" ]]; then
  echo "Nenhuma instância encontrada com o nome $instance_name"
  exit 1
fi

# Exibe um menu para o usuário selecionar a instância desejada
echo "Instâncias encontradas:"
echo ""
echo "$instances" | awk '{print NR,"=>",$0}'
echo ""
read -p "Selecione o número da instância para iniciar uma sessão do SSM: " selection

# Obtém o ID da instância selecionada
instance_id=$(echo "$instances" | awk "NR==$selection{print \$1}")

# Verifica se o usuário selecionou uma opção válida
if [[ -z "$instance_id" ]]; then
  echo "Opção inválida"
  exit 1
fi

# Inicia uma sessão do SSM na instância selecionada
aws ssm start-session --target "$instance_id"
