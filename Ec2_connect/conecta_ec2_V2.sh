#!/bin/bash

# Reset
Color_Off='\033[0m'       # Text Reset
# Regular Colors
Blue='\033[0;34m'         # Blue
Red='\033[0;31m'          # Red
# Bold
BYellow='\033[1;33m'      # Yellow


touch list
echo "Instâncias previamente encontradas:"
echo ""
cat list | sort | uniq -c | sort -nr | awk '{print $2, $3}' | head -n 20 | awk '{print NR,"=>",$0}'
echo -e "${Blue}0 => Para buscar uma instância no console EC2 ☁️ ${Color_Off}"
echo ""
echo -e "${Red}C => Para limpar o histórico de buscar EC2 🚫 ${Color_Off}"
echo ""
echo -e "\033[5m ${BYellow} --->   Para fechar a aplicação pressione CRTL+C <--- ${Color_Off}"
echo ""
read -p "Selecione o número de uma instância para iniciar uma sessão do SSM: " selection_history

if [ "$selection_history" == 'c' ] || [ "$selection_history" == 'C' ]
then
echo -n "" > list
echo " Histórico limpo com sucesso !!! "
clear
elif [ $selection_history -eq 0 ]
then
clear
echo ""
echo -e "\033[5m ${BYellow} --->   Para fechar a aplicação pressione CRTL+C <--- ${Color_Off}"
echo ""
read -p "Digite o nome da instância EC2 que deseja procurar 🖳: " instance_name
instances=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=*$instance_name*" --query "Reservations[*].Instances[*].[InstanceId, Tags[?Key=='Name'].Value | [0]]" --output text | head -n 20)

if [[ -z "$instances" ]]; then
  echo "Nenhuma instância encontrada com o nome $instance_name"
  exit 1
fi

echo "Instâncias encontradas:"
echo ""
echo "$instances" | awk '{print NR,"=>",$0}'
echo ""
echo -e "\033[5m ${BYellow} --->   Para fechar a aplicação pressione CRTL+C <--- ${Color_Off}"
echo ""
read -p "Selecione o número da instância para iniciar uma sessão do SSM 🖧: " selection

instance_id=$(echo "$instances" | awk "NR==$selection{print \$1}")
instance_id_selection=$(echo "$instances" | awk "NR==$selection{print $1}")
echo $instance_id_selection >> list

if [[ -z "$instance_id" ]]; then
  echo "Opção inválida !"
  exit 1
fi
clear
aws ssm start-session --target "$instance_id"

else
instance_id_history=$(cat list | awk "NR==$selection_history{print \$1}")
clear
aws ssm start-session --target "$instance_id_history"

if [[ -z "$instance_id_history" ]]; then
  echo "Opção inválida"
  exit 1
fi
fi