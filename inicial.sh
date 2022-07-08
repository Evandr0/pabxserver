#!/bin/bash
# inicial.sh - Inicia as configurações iniciais para instalação e configurações padrão do pabxserver.
# Site: https://git.intelbras.com.br/ev047953/pabxserver
# Autor: Evandro <evandro.dias@Intelbras.com.br>
# Comando para ser executado no linux -> curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/inicial.sh -O --silent && sleep 5 && sed -i 's/\r$//' inicial.sh && chmod +x inicial.sh && ./inicial.sh
# Comando de teste no gitlab -> curl https://git.intelbras.com.br/ev047953/pabxserver/-/raw/main/inicial.sh -O --silent && sleep 5 && sed -i 's/\r$//' inicial.sh && chmod +x inicial.sh && ./inicial.sh
# Script instala faz configuração do SO linux, criação de usuarios, ftp e comando avançados para o usuario rbash e por fim instala o software do pabxserver. 

#################### Copia o sh onde será possível criar o usuario para acesso ao FTP.


############################################################
#         Necessário para instalação do sngrep             #
############################################################
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/irontec.repo --output /etc/yum.repos.d/irontec.repo --silent &
pid=$!
wait $pid
sed -i 's/\r$//' /etc/yum.repos.d/irontec.repo
rpm --import http://packages.irontec.com/public.key
yum -y update &
pid=$!
wait $pid
############################################################
#                     instalação do FTP                    #
############################################################
yum install -y proftpd &
pid=$!
wait $pid
############################################################
#                     instalação do SNGREP                 #
############################################################
yum install -y sngrep &
pid=$!
wait $pid
############################################################
#                     instalação do net-tools              #
############################################################
yum install -y net-tools &
pid=$!
wait $pid
############################################################
#                     instalação do traceroute             #
############################################################
yum install -y traceroute &
pid=$!
wait $pid

############################################################
# necessário para cópia da chave em caso de instalação de  #
# redundância.                                             #
############################################################
yum install -y sshpass

############################################################
#   Instalação do script para criação do usuario FTP.      #
############################################################
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

############################################################
#              Importa criarusuariobash.sh e executa a     #
#   criação do usuário rbash.  Nome do usuario pabxserver  #
#    Senha pabxserver@intelbras                            #
############################################################
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuariorbash.sh --output criausuariorbash.sh --silent &
pid=$!
wait $pid
sleep 1
chmod +x criausuariorbash.sh
sleep 1
sed -i 's/\r$//' /root/criausuariorbash.sh
sudo ./criausuariorbash.sh

############################################################
# ADICIONA O COMANDO yum clean all ./cleanall.sh           #
############################################################
echo yum clean all > /home/pabxserver/cleanall.sh
chmod +x /home/pabxserver/cleanall.sh

############################################################
# INICIO - ADICIONA SCRIPT HA                              #
############################################################

############################################################
#Passo1 - Cria comando ./passo1.sh                         #
#Possibilita Instalaçãode complementos necessários para HA #
############################################################
echo yum -y install corosync pacemaker pcs lsyncd vitalpbx-high-availability > /home/pabxserver/passo1.sh
chmod +x /home/pabxserver/passo1.sh

############################################################
# Passo 2 - criação do comando ./passo2.sh                 #
#Cria a chave -> ssh-keygen                                #
############################################################
cat > /home/pabxserver/passo2.sh << EOF
#!/bin/bash
ssh-keygen -f /root/.ssh/id_rsa -t rsa -N '' >/dev/null
EOF
chmod +x /home/pabxserver/passo2.sh

############################################################
#Passo 3 - Criação do comando ./passo3.sh                  #
# ssh-copy-id to server                                    #
############################################################
cat > '/home/pabxserver/passo3.sh' << 'EOF'
#!/bin/bash
sshpass -p centos ssh-copy-id -o StrictHostKeyChecking=no root@$1 -p 16022
EOF

chmod +x /home/pabxserver/passo3.sh
############################################################
#Passo 4 - Criação do comando ./pabxserverhap22.sh         #
# Possibilita a instalação de fato do HA                   #
############################################################


curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/pabxserverhap22.sh --output /home/pabxserver/pabxserverhap22.sh --silent &
pid=$!
wait $pid
chmod +x /home/pabxserver/pabxserverhap22.sh
sleep 1
sed -i 's/\r$//' /home/pabxserver/pabxserverhap22.sh
############################################################
############################################################
############################################################

############################################################
# Cria Script para usuario pabxserver pode fazer update no #
# linux - UPDATE   - ./update.sh                           #
############################################################
echo yum -y update > /home/pabxserver/update.sh
sleep 1
chmod +x /home/pabxserver/update.sh

############################################################
# Importa criausuariosevel.sh e                            #
# executa a criação do usuário rbash                       #
# Também importa a chave publica para login ssh            #
############################################################

curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuariodevel.sh --output criausuariodevel.sh --silent &
pid=$!
wait $pid
sleep 1
chmod +x criausuariodevel.sh
sleep 1
sed -i 's/\r$//' /root/criausuariodevel.sh

sudo ./criausuariodevel.sh

############################################################


# ####################################
# /etc/logrotate.d/
# necessário script para "salvar" esse logs no ftp.
############################################################

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