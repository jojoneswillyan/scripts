#!/bin/bash
#ALTERADO POR JONES WILLIAN EM 27-04-2021
DTHR=$(date +%d-%m-%y_%H:%M:%S)
FPASS="pdv2002";
USR=$(whoami)

#sleep 1
#read -p "Raia ou Drogasil: " LOGOMARCA
cd /pdv/vDebug/TCLinux/


main () {
        echo "AGUARDE, TENTANDO CONECTAR NO IP" $1

        ping -c 2 $1 > /dev/null
        RET=$?
        if [ $RET -ne 0 ]
                then
                echo "IP $1 SEM COMUNICACAO!"
        exit
	else 
		process $1

        fi

}
process() {
	echo "Verificando IP: $1"
	sshpass -p $FPASS rsync -e "ssh -o StrictHostKeyChecking=no" --progress /pdv/vDebug/TCLinux/tar/TC.tar.bz2 pdv@$1:/tmp
	sleep 3
	sshpass -p $FPASS ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=10 pdv@$1 << EOF

	echo "Deploy Link PortalTC Lojas $LOGOMARCA"
	echo $FPASS | sudo -S sleep 2
	echo $FPASS | sudo -S tar -xvjf /tmp/TC.tar.bz2 -C /
	sleep 2
	more /home/pdv/.local/share/applications/TC.desktop | grep -e "Exec"
	bash /pdv/vnc-start.sh
	echo "Processo Finalizado"
	
EOF

}

IFS=$'\n'
for next in `cat ./ip.txt`
do
	IFS=' ' eval 'array=($next)'
  	main ${array[0]}
done

