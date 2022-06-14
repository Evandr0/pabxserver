# pabxserver
Script install_pabxserver.sh - Instala todo o sistema do PABX SERVER.
Script criausuariorbash - Cria um usuário com restrições de comandos.
Script criausuarioftp.sh - Será usado pelo usuario rbash para criar um usuario pro ftp.
Script criausuariodevel.sh - Cria o usuario devel, user não pode fazer login com senha, somente com privatekey. (O user devel pode digitar o comando para logar como root)

#User devel.
arquivos public key e private key estão na pasta sshkeygen
passphrare 1nt3lbr@sPABXSERVER
Teste realizado com Bitvise SSH Client 9.16:


#MANUAL PABXSERVER SSH 
- Porta Padrão do SSH: 16022
- Usuario padrão do SSH é pabxserver
- Senha padrão pabxserver@intelbras

Comandos disponíveis.
ls, top, uptime, passwd, lsmod, dmesg, lsusb, df, ping, traceroute,

Comandos disponíveis com sudo
ifconfig, sngrep, ./criausuarioftp.sh, reboot, intelbras, ./update.sh

Sobre o SNGREP. Pasta padrão de salvamento será a pasta /usr/share/vitalpbx/www/ isso faz com que seja possível baixar o arquivo diretamente do navegador WEB acessando o IP do equipamento/nomedoarquivo.pcap
