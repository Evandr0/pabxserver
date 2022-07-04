# pabxserver
Script criausuariorbash - Cria um usuário com restrições de comandos.
Script criausuarioftp.sh - Será usado pelo usuario rbash para criar um usuario pro ftp.
Script criausuariodevel.sh - Cria o usuario devel, user não pode fazer login com senha, somente com privatekey. (O user devel pode digitar o comando para logar como root)
Script logs.sg - Será usado pelo usuario para copiar os arquivos de log e colocar na pasta /home/ftp/bilhetes

#User devel.
arquivos public key e private key estão na pasta sshkeygen
passphrare 1nt3lbr@sPABXSERVER
Teste realizado com Bitvise SSH Client 9.16:


#MANUAL PABXSERVER SSH 
- Porta Padrão do SSH: 16022
- Usuario padrão do SSH é pabxserver
- Senha padrão pabxserver@intelbras

Comandos disponíveis.
ls, top, uptime, passwd, lsmod, dmesg, lsusb, df, ping, traceroute

Comandos disponíveis com sudo
ifconfig, sngrep, reboot, intelbras, route, ./criausuarioftp.sh, ./update.sh, ./logs.sh, ./cleanall.sh
#Ainda falta script HA
comando ifconfig
        Usado para configuração das interfaces de rede.

Comando sngrep
        Usado para debug/caputura do SIP em tempo real.

Comando reboot
        Usado para reiniciar o servidor

Comando intelbras
        reset-pwd [username]    (Comando para reset da senha do usuáruio WEB.)
        build-db                (Execute uma série de scripts para construir o banco de dados PABXServer (apply_patches)
        dump-conf               (Descarregue as configurações do Asterisk e reconstrua o banco de dados do Asterisk (somente Tenant principal)
        fully-dump-conf         (Descarregue as configurações do Asterisk e reconstrua o banco de dados do Asterisk)
        check-integrity         (O comando para verificar a integridade do ambiente, verifica a integridade de cada Locatário e define as permissões corretas para o proprietário/grupo para as pastas.)
        update-pbx              (Atualiza o PBX)
        apply-firewall          (Aplicar regras de firewall)
        restore-backup          (Restaura um backup salvo, necessário especificar o caminho do arquivo | /var/lib/vitalpbx/backup/ )
        reset-apache-conf       (Restaura as configurações do apache, geralmente utilizado quando tiver algum problema com certificado https)

Comando route
        Faz alteração de rotas no linux.

Comando ./criausuarioftp.sh
        Cria o usuario bilhetes para o FTP. (Necessário para configuração de tarifação/controller)


Sobre o SNGREP. Pasta padrão de salvamento será a pasta /usr/share/vitalpbx/www/ isso faz com que seja possível baixar o arquivo diretamente do navegador WEB acessando o IP do equipamento/logs/nomedoarquivo.pcap - Criado link simbólico /home/pabxserver/logs
