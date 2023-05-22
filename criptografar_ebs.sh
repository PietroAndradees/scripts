#!/bin/bash

# Define a chave de criptografia que será usada para criptografar os volumes
key_id="<your-kms-key-id>"

# Obtém a lista de volumes EBS não criptografados
volumes=$(aws ec2 describe-volumes --filters Name=encrypted,Values=false --query Volumes[].VolumeId --output text)

# Para cada volume, desanexe-o da instância e crie um snapshot criptografado
for volume_id in $volumes; do
  # Obtém o ID da instância a qual o volume está anexado
  instance_id=$(aws ec2 describe-volumes --volume-ids $volume_id --query Volumes[].Attachments[].InstanceId --output text)

  # Desanexa o volume
  aws ec2 detach-volume --volume-id $volume_id

  # Cria o snapshot criptografado a partir do volume
  snap_id=$(aws ec2 create-snapshot --volume-id $volume_id --description "Snapshot of volume $volume_id" --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=EncryptedSnapshot}]' --query SnapshotId --output text)
  aws ec2 create-tags --resources $snap_id --tags Key=Name,Value=EncryptedSnapshot

  # Cria o volume criptografado a partir do snapshot
  new_volume_id=$(aws ec2 create-volume --availability-zone $(aws ec2 describe-instances --instance-ids $instance_id --query Reservations[].Instances[].Placement.AvailabilityZone --output text) --snapshot-id $snap_id --volume-type gp2 --encrypted --kms-key-id $key_id --query VolumeId --output text)

  # Anexa o volume criptografado à instância
  aws ec2 attach-volume --volume-id $new_volume_id --instance-id $instance_id --device /dev/sdf

  # Deleta o volume antigo e o snapshot
  aws ec2 delete-volume --volume-id $volume_id
  aws ec2 delete-snapshot --snapshot-id $snap_id
done

