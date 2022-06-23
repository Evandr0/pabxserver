#!/bin/bash
# inicial.sh - Inicia as configurações iniciais para instalação e configurações padrão do pabxserver.
# Site: https://git.intelbras.com.br/ev047953/pabxserver
# Autor: Evandro <evandro.dias@Intelbras.com.br>
# Comando para ser executado no linux -> curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/inicial.sh -O --silent && sleep 5 && sed -i 's/\r$//' inicial.sh && chmod +x inicial.sh && ./inicial.sh
# Comando de teste no gitlab -> curl https://git.intelbras.com.br/ev047953/pabxserver/-/raw/main/inicial.sh -O --silent && sleep 5 && sed -i 's/\r$//' inicial.sh && chmod +x inicial.sh && ./inicial.sh
# Script instala faz configuração do SO linux, criação de usuarios, ftp e comando avançados para o usuario rbash e por fim instala o software do pabxserver. 

#################### Copia o sh onde será possível criar o usuario para acesso ao FTP.
mkdir /home/pabxserver/
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuarioftp.sh --output /home/pabxserver/criausuarioftp.sh --silent &
pid=$!
wait $pid
ls /root
sleep 1
chmod +x /home/pabxserver/criausuarioftp.sh
ls
sleep 1
sed -i 's/\r$//' /home/pabxserver/criausuarioftp.sh

#Importa criarusuariobash.sh e executa a criação do usuário rbash.
#Nome do usuario pabxserver
#Senha pabxserver@intelbras
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuariorbash.sh --output criausuariorbash.sh --silent &
pid=$!
wait $pid
sleep 1
chmod +x criausuariorbash.sh
sleep 1
sed -i 's/\r$//' /root/criausuariorbash.sh
sudo ./criausuariorbash.sh

#baixa script para usuario pabxserver pode fazer update do linux - UPDATE
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/update.sh --output /home/pabxserver/update.sh --silent &
pid=$!
wait $pid
ls /root
sleep 1
chmod +x /home/pabxserver/update.sh
ls
sleep 1
sed -i 's/\r$//' /home/pabxserver/update.sh

#Importa criausuariosevel.sh e executa a criação do usuário rbash
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuariodevel.sh --output criausuariodevel.sh --silent &
pid=$!
wait $pid
sleep 1
chmod +x criausuariodevel.sh
sleep 1
sed -i 's/\r$//' /root/criausuariodevel.sh

sudo ./criausuariodevel.sh

# ####################################
# /etc/logrotate.d/
# necessário script para "salvar" esse logs no ftp.
# script log.sh possibilita a exportação dos logs do sistema para a pasta /home/ftp/bilhetes
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/logs.sh --output /home/pabxserver/logs.sh --silent &
pid=$!
wait $pid
sleep 1
chmod +x /home/pabxserver/logs.sh
sleep 1
sed -i 's/\r$//' /home/pabxserver/logs.sh

yum install -y proftpd
yum install -y sngrep
yum install -y net-tools
yum install -y traceroute
echo "Adicionando ftp no firewall"
firewall-cmd --add-service=ftp --permanent --zone=public &
pid=$!
wait $pid
echo $pid was terminated.
firewall-cmd --reload
echo "Start proftpd"
systemctl start proftpd
systemctl enable proftpd
#Alterar porta SSH para 16022

sed -i 's/^#Port.*/Port 16022/' /etc/ssh/sshd_config
firewall-cmd --zone=public --add-port=16022/tcp --permanent
firewall-cmd --reload
systemctl restart sshd
#Alterar pasta padrão de salvamento sngrep
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/configsngrep --silent --output .sngreprc
sed -i 's/\r$//' /root/.sngreprc

############ Instalação do pabxserver
# curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/install_pabxserver.sh --output install.sh --silent &
# pid=$!
# wait $pid
# chmod +x install.sh & 
# sleep 1
# sed -i 's/\r$//' install.sh
# sleep 2
# sudo ./install.sh
curl -fsSL http://repo.vitalpbx.org/vitalpbx/WL/intelbras/v3/vps/install.sh | bash -