#!/bin/bash
#curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/inicial.sh -O --silent && sleep 5 && sed -i 's/\r$//' inicial.sh && chmod +x inicial.sh && ./inicial.sh
#curl https://git.intelbras.com.br/ev047953/pabxserver/-/raw/main/inicial.sh -O --silent && sleep 5 && sed -i 's/\r$//' inicial.sh && chmod +x inicial.sh && ./inicial.sh
#Script instala Pabxserver e chama outros pacotes de instalação. 
#Importa criarusuarioftp.sh e cria a home do usuario pabxserver.
mkdir /home/pabxserver/
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuarioftp.sh --output /home/pabxserver/criausuarioftp.sh --silent &
pid=$!
wait $pid
ls /root
sleep 1
chmod +x /home/pabxserver/criausuarioftp.sh
ls
sleep 1
sed -i 's/\r$//' /home/pabxserver/criausuarioftp.sh

#Importa cruarusuariobash.sh e executa a criação do usuário rbash
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/criausuariorbash.sh --output criausuariorbash.sh --silent &
pid=$!
wait $pid
sleep 1
chmod +x criausuariorbash.sh
sleep 1
sed -i 's/\r$//' /root/criausuariorbash.sh

sudo ./criausuariorbash.sh




############
curl https://raw.githubusercontent.com/Evandr0/pabxserver/main/install_pabxserver.sh --output install.sh --silent &
pid=$!
wait $pid
chmod +x install.sh & 
sleep 1
sed -i 's/\r$//' install.sh
sleep 2
sudo ./install.sh