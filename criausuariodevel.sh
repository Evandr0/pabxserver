#!/bin/bash
###################################################################################################
# https://maisgeek.com/como-usar-o-shell-restrito-para-limitar-o-que-um-usuario-linux-pode-fazer/ #
# Script cria usuario devel rbash limitado para uso de alguns comandos + su                       #
###################################################################################################



#Cria o caminho rbash.

ln -s /bin/bash /bin/rbash
sleep 1

#adicionar usuario rbash nome devel

sudo useradd devel -d /home/devel -m -s /bin/rbash
sleep 2
cp /etc/skel/.* /home/devel/
mkdir -p /home/devel/bin
mkdir -p /home/devel/sbin

cp /home/pabxserver/criausuarioftp.sh /home/devel/criausuarioftp.sh
chmod +x /home/devel/criarusuarioftp.sh

#Preciso editar o arquivo /home/devel/.bash_profile linha onde temosPATH=$PATH:$HOME/.local/bin:$HOME/bin alterar para PATH=$HOME/bin
ls -a /home/devel/
sed -i 's/^PATH.*/PATH=$HOME\/bin/' /home/devel/.bash_profile

##Permissões para o usuario devel
sudo chown root:root /home/devel/.bash_profile
sudo chmod 755 /home/devel/.bash_profile
chown -R devel:devel /home/devel/criausuarioftp.sh
##

#Dando permissões especificas.
#Alguns comandos para diagnósticos e debug.
ln -s /bin/dmesg /home/devel/bin/
ln -s /bin/ping /home/devel/bin/
ln -s /bin/traceroute /home/devel/bin/
ln -s /sbin/lsmod /home/devel/bin/
ln -s /bin/lsusb /home/devel/bin/
ln -s /bin/df /home/devel/bin/

ln -s /bin/ls /home/devel/bin/
ln -s /bin/ping /home/devel/bin/
ln -s /bin/traceroute /home/devel/bin/
ln -s /bin/passwd /home/devel/bin/
ln -s /bin/top /home/devel/bin/
ln -s /bin/uptime /home/devel/bin/
ln -s /bin/sngrep /home/devel/bin/
ln -s /bin/tcpdump /home/devel/bin/
ln -s /bin/sudo /home/devel/bin/
ln -s /sbin/reboot /home/devel/sbin/
ln -s /sbin/ifconfig /home/devel/sbin/
ln -s /usr/sbin/intelbras /home/devel/sbin/
ln -s /bin/su /home/devel/bin/
sed -i '$a devel ALL=NOPASSWD:/usr/bin/sngrep,/usr/sbin/reboot,/home/devel/criausuarioftp.sh,/usr/sbin/ifconfig,/home/devel/sbin/intelbras,/home/devel/update.sh,/home/devel/logs.sh' /etc/sudoers


############################
############################
#Pega a chave publica para no servidor e liberar o acesso ao usuario devel
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/public.pub --output /home/devel/public.pub --silent &
pid=$!
wait $pid
sleep 1
mkdir /home/devel/.ssh/
sed -i 's/\r$//' /home/devel/public.pub
cp /home/devel/public.pub /home/devel/.ssh/authorized_keys