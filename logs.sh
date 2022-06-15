#!/bin/bash
#Copia os arquivos de log existentes para o ftp do usuario bilhetes /home/ftp/bilhetes
cp -r /var/log/asterisk/ /home/ftp/bilhetes/logs
# /var/log/asterisk/event_log
# /var/log/asterisk/full
# /var/log/asterisk/dtmf
# /var/log/asterisk/fail2ban
cp -r /var/spool/mail/ /home/ftp/bilhetes/logs/mail
cp -r /var/log/asterisk/queue_log /home/ftp/bilhetes/logs

cp -r /var/log/boot.log /home/ftp/bilhetes/logs
cp -r /var/log/chrony/*.log /home/ftp/bilhetes/logs
cp -r /var/log/fail2ban.log /home/ftp/bilhetes/logs
cp -r /var/log/firewalld /home/ftp/bilhetes/logs
cp -r /var/log/httpd/*log /home/ftp/bilhetes/logs
cp -r /var/lib/mysql/*.log /home/ftp/bilhetes/logs
cp -r /var/log/php-fpm/*log /home/ftp/bilhetes/logs
cp -r /var/log/proftpd/*.log /home/ftp/bilhetes/logs
cp -r /var/log/cron /home/ftp/bilhetes/logs
cp -r /var/log/maillog /home/ftp/bilhetes/logs
cp -r /var/log/messages /home/ftp/bilhetes/logs
cp -r /var/log/secure /home/ftp/bilhetes/logs
cp -r /var/log/spooler /home/ftp/bilhetes/logs
cp -r /var/log/vitalpbx/authentications.log /home/ftp/bilhetes/logs
cp -r /var/log/asterisk/cdr-custom/VPBX.csv /home/ftp/bilhetes/logs
cp -r /var/log/asterisk/cdr-csv/Master.csv /home/ftp/bilhetes/logs
cp -r /var/log/wpa_supplicant.log /home/ftp/bilhetes/logs
cp -r /var/log/yum.log /home/ftp/bilhetes/logs