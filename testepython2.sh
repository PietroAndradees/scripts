#!/bin/bash

# Pedir ao usuário que digite o nome da instância que deseja encontrar
read -p "Digite o nome da instância que deseja encontrar: " instance_name

# Listar as IDs das instâncias que contenham exatamente o nome digitado pelo usuário
instance_ids=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${instance_name}" --query 'Reservations[*].Instances[*].InstanceId' --output text | head -n 15)

# Verificar se foram encontradas instâncias com o nome informado
if [ -z "$instance_ids" ]; then
  echo "Não foram encontradas instâncias com o nome '$instance_name'"
  exit 1
fi

# Exibir um menu de seleção com as IDs das instâncias encontradas
echo "Foram encontradas as seguintes instâncias com o nome '$instance_name':"
PS3="Selecione uma instância para conectar ao SSM start-session: "
select instance_id in $instance_ids; do
  if [ -n "$instance_id" ]; then
    # Iniciar o SSM start-session com a instância selecionada
    aws ssm start-session --target "$instance_id"
    break
  else
    echo "Opção inválida. Selecione um número de 1 a $(echo "$instance_ids" | wc -w)"
  fi
done
