#!/bin/bash
#ALTERADO POR JONES WILLIAN EM 27-04-2021
DTHR=$(date +%d-%m-%y_%H:%M:%S)
HOST_CAIXA=$1
FPASS="pdv2002";
USR=$(whoami)

TP=`ps -aux | grep tc-printer | grep -v grep | awk -F ' ' '{print $2,$16}'`
TS=`ps -aux | grep tc-scanner | grep -v grep | awk -F ' ' '{print $2, $19}'`
TB=`ps -aux | grep tc-biometria | grep -v grep | awk -F ' ' '{print $2, $17}'`


sleep 1

cd /pdv/vDebug/TCLinux/


	if [ "$HOST_CAIXA" == "" ];
		then
	echo "ERROR ---> IP CAIXA INVALIDO!"
	exit;
	fi

	echo "AGUARDE, TENTANDO CONECTAR NO IP ["${HOST_CAIXA}"]"

	ping -c 2 ${HOST_CAIXA} > /dev/null
	RET=$?
	if [ $RET -ne 0 ]
		then
		echo "IP [${HOST_CAIXA}] SEM COMUNICACAO!"
	exit
	fi


process() {
	echo "Verificando IP: $1"
		sshpass -p $FPASS ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=10 pdv@$1 << EOF

	echo "Reiniciando Services tc-printer, tc-scanner, tc-biometria..."
		echo $FPASS | sudo -S systemctl daemon-reload
		echo $FPASS | sudo -S systemctl restart tc-printer.service
		echo $FPASS | sudo -S systemctl daemon-reload
		echo $FPASS | sudo -S systemctl restart tc-scanner.service
		echo $FPASS | sudo -S systemctl daemon-reload
		echo $FPASS | sudo -S systemctl status tc-biometria.service
		echo $FPASS | sudo -S systemctl daemon-reload
		echo $FPASS | sudo -S systemctl status tc-printer.service tc-biometria.service tc-scanner.service | grep -e "Loaded" -e "Active"
	echo "Processo tc-printer.service $1"
		$TP 
	echo "Processo tc-scanner.service $1 "
		$TS 
	echo "Processo tc-biometria.service $1"
		$TB 
EOF

}

process $1

