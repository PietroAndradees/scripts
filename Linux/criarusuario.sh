#!/bin/bash
NOME=$1
uFGBLINK="\033[5m"
uFGRESET="\033[0m"
if [[ -z $NOME ]]; then
echo ""
echo -e "Nenhum nome foi adicionado ao script, por favor insira ao lado Ex: ${uFGBLINK}novotunnel nome.sobrenome${uFGRESET}"
echo ""
  exit 1
fi
useradd -m $NOME
mkdir /home/$NOME/.ssh/
chmod 700 /home/$NOME/.ssh/
touch /home/$NOME/.ssh/authorized_keys
chmod 600 /home/$NOME/.ssh/authorized_keys
chmod 700 /home/$NOME/.ssh/
chown -R $NOME:$NOME /home/$NOME/
chown -R $NOME:$NOME /home/$NOME/.ssh/authorized_keys
nano /home/$NOME/.ssh/authorized_keys
#echo -e "$NOME                            ALL = NOPASSWD: ALL\n$NOME                            ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/zoox