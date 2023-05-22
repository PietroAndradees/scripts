#!/bin/bash

# Listar todas as instâncias com a tag elasticbeanstalk:environment-id
#instances=$(aws ec2 describe-instances --filters "Name=tag-key,Values=elasticbeanstalk:environment-id" --query "Reservations[].Instances[].{Name: Tags[?Key=='Name']|[0].Value, InstanceId: InstanceId}" --output text)

instances=$(aws ec2 describe-instances --filters "Name=tag-key,Values=elasticbeanstalk:environment-id" --query "Reservations[].Instances[].InstanceId" --output text)

instance_name="hotspot-staging"

	aws ec2 create-security-group --group-name "$instance_name-sg" --description "Security group for $instance_name" --vpc-id "vpc-3a8ef05e" --tag-specifications "ResourceType=security-group,Tags=[{Key=Name,Value=$instance_name-sg},{Key=name,Value=$instance_name},{Key=owner,Value=mario.costa},{Key=created-by,Value=pietro.andrade},{Key=created-at,Value=2023-03-02}]" > /dev/null
  
# Obter o ID do security group recém-criado
	sg_id=$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$instance_name-sg" --query "SecurityGroups[].GroupId" --output text)

# Adicionar uma regra de entrada ao security group para permitir o tráfego HTTP (porta 80)
	#aws ec2 authorize-security-group-ingress --group-id "$sg_id" --protocol tcp --port 80 --cidr 10.64.0.0/16 --description 'VPC ZooxWiFi' > /dev/null
#	aws ec2 authorize-security-group-egress --group-id "$sg_id" --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges=[{CidrIp='10.64.0.0/16', Description='ZooxWiFi'}]
	
	aws ec2 authorize-security-group-ingress --group-id "$sg_id" --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges="[{CidrIp='10.64.0.0/16',Description='VPC'}]"


	
	#aws ec2 authorize-security-group-ingress --group-id "$sg_id" --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,UserIdGroupPairs='[{GroupId=sg-030dc5ea0370be270, Description='Permission sg ELB shared'}]' > /dev/null
	####
	#aws ec2 authorize-security-group-engress --group-id "$sg_id" --protocol tcp --port 80 --cidr 10.64.0.0/16 > /dev/null
  
	echo "Security group criado para a instância $instance_name com sucesso."

