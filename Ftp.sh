#!/bin/bash
#Instala servidor proftpd e SNGREP
#Comando será feito na produção para instalação do proftpd e SNGREP.
set -e

#Disable Selinux Temporarily
SELINUX_STATUS=$(getenforce)
if [ "$SELINUX_STATUS" != "Disabled" ]; then
    echo "Disabling SELINUX Temporarily"
    setenforce 0
else
  echo "SELINUX it is already disabled"
fi

#Disable SeLinux Permanently
sefile="/etc/selinux/config"
if [ -e $sefile ]
then
  sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
fi

#Instal proftpd
yum -y install proftpd &
pid=$!
wait $pid
echo $pid was terminated.
yum -y install sngrep &
pid=$!
wait $pid
echo Instalação sngrep terminou

# Enable and Start Firewall
firewall-cmd --add-service=ftp --permanent --zone=public &
pid=$!
wait $pid
echo $pid was terminated.
firewall-cmd --reload
#Enable and Start Proftpd
systemctl start proftpd
systemctl enable proftpd

# Reboot System to Make Selinux Change Permanently
echo "Rebooting System"
reboot