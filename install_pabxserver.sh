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
yum install -y proftpd
yum install -y sngrep
yum install -y net-tools
yum install -y traceroute
#################################################################################################

# curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/Ftp.sh --output Ftp.sh --silent
# chmod +x Ftp.sh
# ./Ftp.sh
#Se der certo, tirar o reboot do arquivo SH.
#################################################################################################

# Clean Cache Again
yum clean all
rm -rf /var/cache/yum

# Install Intelbras
mkdir -p /etc/vitalpbx
mkdir -p /etc/asterisk/vitalpbx
yum -y install intelbras intelbras-asterisk-configs vitalpbx-fail2ban-config intelbras-sounds intelbras-themes

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

#Instalação FTP by Intelbras
# Enable and Start Firewall
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
#sed -i 's/^set savepath.*/set savepath /usr/share/vitalpbx/www/' /root/.sngreprc



# Reboot System to Make Selinux Change Permanently
echo "Rebooting System"
reboot
