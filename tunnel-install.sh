#!/bin/bash
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sleep 2

read -p "Qual gerenciador de pacotes você está usando? (apt/yum): " resposta

if [ "$resposta" = "apt" ]; then
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
  sudo dpkg -i session-manager-plugin.deb
  touch ~/.ssh/config
  echo "# SSH over Session Manager
host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"" >> ~/.ssh/config
  sudo apt-get install sshuttle -y
  cd /usr/local/bin
  sudo wget https://raw.githubusercontent.com/PietroAndradees/scripts/main/tunnel-ssm-V2.sh -O tunnel-aws
  sudo chmod +x tunnel-aws
  sudo nano tunnel-aws
elif [ "$resposta" = "yum" ]; then
  sudo yum install -y https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm
  touch ~/.ssh/config
  echo "# SSH over Session Manager
host i-* mi-*
    ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"" >> ~/.ssh/config
  sudo yum install -y sshuttle
  cd /usr/local/bin
  sudo wget https://raw.githubusercontent.com/PietroAndradees/scripts/main/tunnel-ssm-V2.sh -O tunnel-aws
  sudo chmod +x tunnel-aws
  sudo nano tunnel-aws
else
  echo "Resposta inválida. Por favor, insira 'apt' ou 'yum'."
fi

echo "Script finalizado. Para executá-lo, execute o comando 'tunnel-aws'."
echo "Não se esqueça de configurar o arquivo 'tunnel-aws' para o seu usuário e de rodar o comando "aws configure sso" caso nunca tenha utilizado o AWS CLI"