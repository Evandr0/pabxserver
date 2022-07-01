#!/bin/bash
# Site: https://git.intelbras.com.br/ev047953/pabxserver
# Autor: Evandro <evandro.dias@Intelbras.com.br>
##############################################################
#https://maisgeek.com/como-usar-o-shell-restrito-para-limitar-o-que-um-usuario-linux-pode-fazer/
#Script cria usuario rbash limitado para uso de alguns comandos.
###############################################################



#Verifica se o caminho rbash existe, cria ele se não existir.

ln -s /bin/bash /bin/rbash
sleep 1

#adicionar usuario rbash nome pabxserver
#useradd maria1 -s /bin/rbash; (echo maria123; echo maria123) | passwd maria1

sudo useradd pabxserver -d /home/pabxserver -m -s /bin/rbash && (echo pabxserver@intelbras; echo pabxserver@intelbras) | passwd pabxserver
sleep 2
cp /etc/skel/.* /home/pabxserver/
mkdir -p /home/pabxserver/bin
mkdir -p /home/pabxserver/sbin
mkdir -p /home/pabxserver/logs

#Preciso editar o arquivo /home/pabxserver/.bash_profile linha onde temosPATH=$PATH:$HOME/.local/bin:$HOME/bin alterar para PATH=$HOME/bin
echo "verificando se o arquivo bash_profile existe"
ls -a /home/pabxserver/
sed -i 's/^PATH.*/PATH=$HOME\/bin/' /home/pabxserver/.bash_profile

##Permissões para o usuario pabxserver
sudo chown root:root /home/pabxserver/.bash_profile
sudo chmod 755 /home/pabxserver/.bash_profile
chown -R pabxserver:pabxserver /home/pabxserver/criausuarioftp.sh
##

#Dando permissões especificas.
#Alguns comandos para diagnósticos e debug.
ln -s /bin/dmesg /home/pabxserver/bin/
ln -s /bin/ping /home/pabxserver/bin/
ln -s /bin/traceroute /home/pabxserver/bin/
ln -s /sbin/lsmod /home/pabxserver/bin/
ln -s /bin/lsusb /home/pabxserver/bin/
ln -s /bin/df /home/pabxserver/bin/
ln -s /bin/asterisk /home/pabxserver/bin/
ln -s /sbin/asterisk /home/pabxserver/sbin/
ln -s /bin/ls /home/pabxserver/bin/
ln -s /bin/passwd /home/pabxserver/bin/
ln -s /bin/top /home/pabxserver/bin/
ln -s /bin/uptime /home/pabxserver/bin/
ln -s /bin/sngrep /home/pabxserver/bin/
ln -s /bin/tcpdump /home/pabxserver/bin/
ln -s /bin/sudo /home/pabxserver/bin/
ln -s /sbin/reboot /home/pabxserver/sbin/
ln -s /sbin/ifconfig /home/pabxserver/sbin/
ln -s /usr/sbin/intelbras /home/pabxserver/sbin/
ln -s /usr/sbin/route /home/pabxserver/sbin/

sed -i '$a pabxserver ALL=NOPASSWD:/usr/bin/sngrep,/home/pabxserver/pabxserverha.sh,/home/pabxserver/cleanall.sh,/usr/sbin/route,/usr/sbin/reboot,/home/pabxserver/criausuarioftp.sh,/usr/sbin/ifconfig,/home/pabxserver/sbin/intelbras,/home/pabxserver/update.sh,/home/pabxserver/logs.sh,/usr/sbin/asterisk' /etc/sudoers


############################
############################