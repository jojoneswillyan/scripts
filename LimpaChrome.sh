#!/bin/bash
#ALTERADO POR JONES WILLIAN EM 27-04-2021
DTHR=$(date +%d-%m-%y_%H:%M:%S)
HOST_CAIXA=$1
FPASS="pdv2002";
USR=$(whoami)

sleep 1
cd /pdv/vDebug/TCLinux/deb/google


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
        sshpass -p $FPASS rsync -e "ssh -o StrictHostKeyChecking=no" --progress /pdv/vDebug/TCLinux/deb/google/kill_chrome.sh pdv@$1:/tmp
        sshpass -p $FPASS ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=10 pdv@$1 << EO
F

        echo "Limpando .cache Google Chrome Browser"
        sleep 5
        echo $FPASS | sudo -S google-chrome-stable --version
        echo $FPASS | sudo -S cp -prv /tmp/kill_chrome.sh /opt/google/chrome/kill_chrome.sh
        bash /opt/google/chrome/kill_chrome.sh
        echo $FPASS | sudo -S rm -rf /home/pdv/.cache/google-chrome/Default/Cache/*
        echo $FPASS | sudo -S google-chrome-stable --version
        echo "PROCESSO FINALIZADO $1"
EOF

}

process $1
