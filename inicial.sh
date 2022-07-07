#!/bin/bash
# inicial.sh - Inicia as configurações iniciais para instalação e configurações padrão do pabxserver.
# Site: https://git.intelbras.com.br/ev047953/pabxserver
# Autor: Evandro <evandro.dias@Intelbras.com.br>
# Comando para ser executado no linux -> curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/inicial.sh -O --silent && sleep 5 && sed -i 's/\r$//' inicial.sh && chmod +x inicial.sh && ./inicial.sh
# Comando de teste no gitlab -> curl https://git.intelbras.com.br/ev047953/pabxserver/-/raw/main/inicial.sh -O --silent && sleep 5 && sed -i 's/\r$//' inicial.sh && chmod +x inicial.sh && ./inicial.sh
# Script instala faz configuração do SO linux, criação de usuarios, ftp e comando avançados para o usuario rbash e por fim instala o software do pabxserver. 

#################### Copia o sh onde será possível criar o usuario para acesso ao FTP.

# [root@server1 ~]# yum -y install wget lsyncd
# [root@server2 ~]# yum -y install wget lsyncd

# [root@server1 ~]# ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' >/dev/null
# [root@server1 ~]# ssh-copy-id root@192.168.10.62
# Are you sure you want to continue connecting (yes/no)? yes
# root@192.168.10.62's password: (remote server root’s password)

# Number of key(s) added: 1

# Now try logging into the machine, with:   "ssh 'root@192.168.10.62'"
# and check to make sure that only the key(s) you wanted were added. 

# [root@server2 ~]# ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' >/dev/null
# [root@server2 ~]# ssh-copy-id root@192.168.10.61
# Are you sure you want to continue connecting (yes/no)? yes
# root@192.168.10.61's password: (remote server root’s password)

# Number of key(s) added: 1

# Now try logging into the machine, with:   "ssh 'root@192.168.10.61'"
# and check to make sure that only the key(s) you wanted were added. 








############################################################
#Necessário para instalação do sngrep
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/irontec.repo --output /etc/yum.repos.d/irontec.repo --silent &
pid=$!
wait $pid
sed -i 's/\r$//' /etc/yum.repos.d/irontec.repo
rpm --import http://packages.irontec.com/public.key
yum -y update &
pid=$!
wait $pid

yum install -y proftpd &
pid=$!
wait $pid

yum install -y sngrep &
pid=$!
wait $pid

yum install -y net-tools &
pid=$!
wait $pid

yum install -y traceroute &
pid=$!
wait $pid


#necessário para cópia da chave em caso de instalação de redundância.
yum install -y sshpass

####Instalação do script para criação do usuario FTP.
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

#########
#ADICIONAR COMANDO yum clean all
echo yum clean all > /home/pabxserver/cleanall.sh
chmod +x /home/pabxserver/cleanall.sh
###########
#
#ADICIONAR SCRIPT HA

#Passo1 - yum -y install corosync pacemaker pcs lsyncd vitalpbx-high-availability
echo yum -y install corosync pacemaker pcs lsyncd vitalpbx-high-availability > /home/pabxserver/passo1.sh
chmod +x /home/pabxserver/passo1.sh

#Passo 2 - criação ssh-keygen
newfile=/home/pabxserver/passo2.sh
(
<< 'EOF'
ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' > /dev/null
EOF
)
> $newfile
chmod +x /home/pabxserver/passo2.sh

#Passo 3 - ssh-copy-id to server
(
<< 'EOF'
sshpass -p centos ssh-copy-id -p 16022 root@$1
EOF
)
> /home/pabxserver/passo3.sh
chmod +x /home/pabxserver/passo3.sh

curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/pabxserverhap22.sh --output /home/pabxserver/pabxserverhap22.sh --silent &
pid=$!
wait $pid
chmod +x /home/pabxserver/pabxserverhap22.sh
sleep 1
sed -i 's/\r$//' /home/pabxserver/pabxserverhap22.sh


#
#baixa script para usuario pabxserver pode fazer update do linux - UPDATE
echo yum -y update > /home/pabxserver/update.sh
sleep 1
chmod +x /home/pabxserver/update.sh

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

#Instala PABXSERVER
#curl -fsSL http://repo.vitalpbx.org/vitalpbx/WL/intelbras/v3/vps/install.sh | bash -
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/install.sh --output install.sh --silent &
pid=$!
wait $pid
chmod +x install.sh
sleep 1
sed -i 's/\r$//' install.sh
sleep 1
sudo ./install.sh


https://github.com/Evandr0/pabxserver/blob/main/pabxserverhap22.sh