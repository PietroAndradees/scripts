#!/bin/bash

# Obtenha uma lista de IDs de volume
volume_ids=$(aws ec2 describe-volumes --filters Name=volume-type,Values=gp2 --query "Volumes[*].VolumeId" --output text)

# Altere o tipo de volume de gp2 para gp3
for volume_id in $volume_ids; do
    echo "Alterando o tipo de volume $volume_id"
    aws ec2 modify-volume --volume-id $volume_id --volume-type gp3 > /dev/null
done

