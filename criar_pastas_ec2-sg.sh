#!/bin/bash

instances=$(aws ec2 describe-instances --filters "Name=tag-key,Values=elasticbeanstalk:environment-id" --query "Reservations[].Instances[].InstanceId" --output text)

for name_is in $instances
do

instance_name=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$name_is" "Name=key,Values=Name" --query "Tags[].Value" --output text)

	mkdir $instance_name

	echo "Pasta $instance_name criada com sucesso."
done

