#!/bin/bash
#Script instala Pabxserver e chama outros pacotes de instalação. 
#Importa criarusuarioftp.sh e cria a home do usuario pabxserver.
mkdir /home/pabxserver/
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuarioftp.sh --output /home/pabxserver/criausuarioftp.sh --silent &
pid=$!
wait $pid
chmod +x /home/pabxserver/criausuarioftp.sh
sed -i 's/\r$//' criausuarioftp.sh

#Importa cruarusuariobash.sh e executa a criação do usuário rbash
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuariorbash.sh --output criausuariorbash.sh --silent &
pid=$!
wait $pid
sed -i 's/\r$//' criausuariorbash.sh
sleep 1
chmod +x criausuariorbash.sh
sudo ./criausuariorbash.sh
#importar senha.sh




############
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/install_pabxserver.sh --output install.sh --silent &
pid=$!
wait $pid
chmod +x install.sh & 
sleep 1
sed -i 's/\r$//' install.sh
sleep 2
sudo ./install.sh