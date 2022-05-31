#!/bin/bash
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
##################################################################
yum -y install proftpd
useradd pabxserver -d /home/pabxserver
passwd pabxserver
chown -R pabxserver:pabxserver /home/pabxserver/
# Enable and Start Firewall
firewall-cmd --add-service=ftp --permanent --zone=public
firewall-cmd --reload
# Enable and Start Proftpd
systemctl start proftpd
systemctl enable proftpd
###################################################################
# Reboot System to Make Selinux Change Permanently
echo "Rebooting System"
reboot