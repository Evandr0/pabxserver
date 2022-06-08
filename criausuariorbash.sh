#!/bin/bash
##############################################################
#https://maisgeek.com/como-usar-o-shell-restrito-para-limitar-o-que-um-usuario-linux-pode-fazer/
#Script cria usuario rbash limitado para uso de alguns comandos.
###############################################################

#Verifica se o caminho rbash existe, cria ele se não existir.
caminhorbash="/bin/rbash"
if [ -e !$caminhorbash ]
then
ln -s /bin/bash /bin/rbash
fi
#adicionar usuario rbash nome pabxserver
#useradd maria1 -s /bin/rbash; (echo maria123; echo maria123) | passwd maria1 
useradd pabxserver3 -s /bin/rbash; (echo pabxserver@intelbras; echo pabxserver@intelbras) | passwd pabxserver3
mkdir -p /home/pabxserver3/bin
mkdir -p /home/pabxserver3/sbin

#Preciso editar o arquivo /home/pabxserver/.bash_profile linha onde temosPATH=$PATH:$HOME/.local/bin:$HOME/bin alterar para PATH=$HOME/bin
sed -i ' s/^PATH.*/PATH=$HOME\/bin/' /home/pabxserver3/.bash_profile

##Permissões para o usuario pabxserver
sudo chown root:root /home/pabxserver3/.bash_profile
sudo chmod 755 /home/pabxserver3/.bash_profile
chown -R pabxserver3:pabxserver3 /home/pabxserver3/
##

#Dando permissões especificas.

ln -s /bin/ls /home/pabxserver3/bin/
ln -s /bin/passwd /home/pabxserver3/bin/
ln -s /bin/top /home/pabxserver3/bin/
ln -s /bin/uptime /home/pabxserver3/bin/
ln -s /bin/sngrep /home/pabxserver3/bin/
ln -s /bin/tcpdump /home/pabxserver3/bin/
ln -s /bin/sudo /home/pabxserver3/bin/
ln -s /sbin/reboot /home/pabxserver3/sbin/
ln -s /sbin/ifconfig /home/pabxserver3/sbin/
sed -i '$a pabxserver3 ALL=NOPASSWD:/usr/bin/sngrep,/usr/sbin/reboot,/home/pabxserver3/criausuarioftp.sh,/usr/sbin/ifconfig,/home/pabxserver3/senha.sh' /etc/sudoers
