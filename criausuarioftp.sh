#!/bin/bash
#Programa que será executado por um usuário para que seja criado um usuario exclusivo para o FTP.
#Será criado o usuario bilhetes e ele somente terá acesso a utilização do ftp.
#precisa dar permissão para o usuario rbash no sudoers para que esse comando funcione para o usuario desejado
#https://maisgeek.com/como-usar-o-shell-restrito-para-limitar-o-que-um-usuario-linux-pode-fazer/  
#http://ptcomputador.com/Networking/ftp-telnet/66521.html criar usuario somente FTP
#https://under-linux.org/showthread.php?t=54214 Script
#Arquivo deve existir na home do usuário /home/pabxserver/CriaUsuarioFTP.sh

echo -e "\e[0;32m"""
echo -n "Criando o usuario bilhetes para utilização do FTP: "
echo
echo -e "\e[0;37m"""


mkdir /home/ftp/
mkdir /home/ftp/bilhetes
cut -d: -f1 /etc/passwd | grep "bilhetes" &> /dev/null
test "$?" -eq "0" && echo "Usuario ja Existe" || sudo useradd -d /home/ftp/bilhetes/ -s /dev/null bilhetes
# sudo useradd -d /home/ftp/bilhetes/ -s /dev/null bilhetes
sudo passwd bilhetes

echo -e "\e[0;32m"""
echo -n "!!! Login = bilhetes "
echo -e "\e[0;37m"""

# Digite o comando " vi /etc /shells " para abrir o arquivo "/etc/shells " no editor de texto vi . 
# Substitua o " vi" com seu editor de texto preferido. Adicione a linha " /dev /null " para o final do arquivo . Salvar e fechar o arquivo.
#verifica o arquivo /etc/shells se existe a linha /dev/null e cria se não tiver.
cut -d: -f1 /etc/shells | grep "/dev/null" &> /dev/null
test "$?" -eq "0" && echo "" || sed -i '$a /dev/null' /etc/shells




#sudo useradd -d /home/ftp/bilhetes/ -s /dev/null bilhetes > /dev/null 2>&1