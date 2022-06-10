#!/bin/bash
##############################################################
#https://maisgeek.com/como-usar-o-shell-restrito-para-limitar-o-que-um-usuario-linux-pode-fazer/
#Script cria usuario rbash limitado para uso de alguns comandos.
###############################################################

#Verifica se o caminho rbash existe, cria ele se não existir.

ln -s /bin/bash /bin/rbash
sleep 1

#adicionar usuario rbash nome devel
#useradd maria1 -s /bin/rbash; (echo maria123; echo maria123) | passwd maria1

sudo useradd devel -d /home/devel -m -s /bin/rbash
sleep 2
cp /etc/skel/.* /home/devel/
mkdir -p /home/devel/bin
mkdir -p /home/devel/sbin

#Preciso editar o arquivo /home/devel/.bash_profile linha onde temosPATH=$PATH:$HOME/.local/bin:$HOME/bin alterar para PATH=$HOME/bin
echo "verificando se o arquivo bash_profile existe"
ls -a /home/devel/
sed -i 's/^PATH.*/PATH=$HOME\/bin/' /home/devel/.bash_profile

##Permissões para o usuario devel
sudo chown root:root /home/devel/.bash_profile
sudo chmod 755 /home/devel/.bash_profile
chown -R devel:devel /home/devel/criausuarioftp.sh
##

#Dando permissões especificas.

ln -s /bin/ls /home/devel/bin/
ln -s /bin/passwd /home/devel/bin/
ln -s /bin/top /home/devel/bin/
ln -s /bin/uptime /home/devel/bin/
ln -s /bin/sngrep /home/devel/bin/
ln -s /bin/tcpdump /home/devel/bin/
ln -s /bin/sudo /home/devel/bin/
ln -s /sbin/reboot /home/devel/sbin/
ln -s /sbin/ifconfig /home/devel/sbin/
ln -s /usr/sbin/intelbras /home/devel/sbin/
sed -i '$a devel ALL=NOPASSWD:/usr/bin/sngrep,/usr/sbin/reboot,/home/devel/criausuarioftp.sh,/usr/sbin/ifconfig,/home/devel/sbin/intelbras' /etc/sudoers


############################
############################
## Criar usuario devel e adicionar chave ECD