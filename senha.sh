#!/bin/bash -r
#Programa que será executado por um usuário para que seja alterado a senha do usuario bilhetes, exclusivo para o FTP.

#precisa dar permissão para o usuario rbash no /etc/sudoers
#http://ptcomputador.com/Networking/ftp-telnet/66521.html
#Arquivo deve existir na home do usuário /home/pabxserver/senha.sh

echo -e "\e[0;32m"""
echo -n "Alterando a senha do usuário bilhetes para utilização do FTP: "
echo -n "Por favor digite uma senha forte: "
echo
echo -e "\e[0;37m"""

sudo passwd bilhetes
