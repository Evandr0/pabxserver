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

#Clean Yum Cache
yum clean all
rm -rf /var/cache/yum

#Download the Intelbras repo
rm -rf /etc/yum.repos.d/intelbras.repo
curl http://repo.vitalpbx.org/vitalpbx/WL/intelbras/v3/vps/intelbras.repo --output /etc/yum.repos.d/intelbras.repo --silent

#Install SSH Welcome Banner
rm -rf /etc/profile.d/vitalwelcome.sh
curl http://repo.vitalpbx.org/vitalpbx/WL/intelbras/v3/vps/SSHBanner.sh --output /etc/profile.d/vitalwelcome.sh --silent
chmod 644 /etc/profile.d/vitalwelcome.sh

#Intall other required dependencies
yum -y install epel-release php

# Clean Cache Again
yum clean all
rm -rf /var/cache/yum

#Install MariaDB (MySQL)
yum install MariaDB-server MariaDB-client MariaDB-common MariaDB-compat mariadb-connector-odbc -y
systemctl enable mariadb
rm -rf /etc/my.cnf.d/vitalpbx.cnf
curl https://raw.githubusercontent.com/VitalPBX/VPS/vitalpbx-3/resources/vitalpbx.cnf --output /etc/my.cnf.d/vitalpbx.cnf --silent
systemctl start mariadb

# Install Intelbras pre-requisites
curl https://raw.githubusercontent.com/VitalPBX/VPS/vitalpbx-3/resources/pack_list --output pack_list --silent
yum -y install $(cat pack_list)

# Enable and Start Firewall
systemctl enable firewalld
systemctl start firewalld

# Clean Cache Again
yum clean all
rm -rf /var/cache/yum

# Install Intelbras
mkdir -p /etc/vitalpbx
mkdir -p /etc/asterisk/vitalpbx
yum -y install intelbras intelbras-asterisk-configs vitalpbx-fail2ban-config intelbras-sounds intelbras-themes asterisk-sounds-pt_BR_Bruna-ulaw

# Do a full update
yum update -y

# Speed up the localhost name resolving
sed -i 's/^hosts.*$/hosts:      myhostname files dns/' /etc/nsswitch.conf

cat << EOF >> /etc/sysctl.d/10-vitalpbx.conf
# Reboot machine automatically after 20 seconds if it kernel panics
kernel.panic = 20
EOF

# Set permissions
chown -R apache:root /etc/asterisk/vitalpbx

# Restart httpd
systemctl restart httpd

#Start vpbx-setup.service
systemctl start vpbx-setup.service

# Enable the http access:
firewall-cmd --add-service=http
firewall-cmd --reload

#Link simb??lico para salvar arquivo na pasta www
ln -s /home/pabxserver/logs /usr/share/vitalpbx/www/

# Reboot System to Make Selinux Change Permanently
echo "Rebooting System"
reboot
