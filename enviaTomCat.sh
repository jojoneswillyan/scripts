#!/bin/bash

cd /pdv/vTomcat

DATA=`date +%Y%m%d`
FPASS="pdv2002";
HOST_CAIXA=$1;

DTHR=$(date +%d-%m-%y_%H:%M:%S)
DT=$(date +%d-%m-%y)
DTP=$(date +%m%Y)
ARC="/pdv/vDebug/oprArquivos/$DTP/tomCat_$DT.txt"
USR=$(whoami)


        echo "$1 $USR $DTHR TomCat" >> $ARC
        chmod -R 777 /pdv/vDebug/oprArquivos/$DTP/* > /dev/null 2>&1

process() {
        sshpass -p $FPASS rsync -e "ssh -o StrictHostKeyChecking=no" --progress tomcat2.tar.bz2 tomcat tomcat.service pdv@${HOST_CAIXA}:/tmp/
        sshpass -p $FPASS ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=4 pdv@${HOST_CAIXA}  << EOF
        TOMCAT_BZ2=\`ls /tmp/tomcat2.tar.bz2 | wc -l\`
        UBUNTU_VER=\`lsb_release -r -s\`

        if [ \$TOMCAT_BZ2 -eq 1 ]; then
                echo "FINALIZANDO PROGRAMAS NA PORTA :8080 !!"
                TOMCAT_PID=\`ps ax | grep tomcat | grep -v grep | awk '{print \$1}'\`
                kill -9 \$TOMCAT_PID
                sleep 2
                echo $FPASS | sudo -S rm -rf /server/tomcat

                tar -xvjf /tmp/tomcat2.tar.bz2 -C /server/
                echo $FPASS | sudo -S chown -R pdv. /server

                if [ "\$UBUNTU_VER" == "10.10" ]; then
                        echo $FPASS | sudo -S chmod -R 777 /etc/init.d/tomcat
                        echo $FPASS | sudo -S mv /tmp/tomcat /etc/init.d/
                        echo $FPASS | sudo -S mv /usr/java/jre1.8.0_144/ /usr/java/jre1.8
                        echo $FPASS | sudo -S chown root. /etc/init.d/tomcat
                        echo $FPASS | sudo -S update-rc.d tomcat defaults
                        echo $FPASS | sudo -S update-rc.d tomcat enable
                        echo $FPASS | sudo -S service tomcat restart
                        echo $FPASS | sudo -S sleep 3
                        echo $FPASS | sudo -S ldconfig
                else
                        echo $FPASS | sudo -S mv /tmp/tomcat.service /etc/systemd/system/
                        echo $FPASS | sudo -S chown root. /etc/systemd/system/tomcat.service
                        echo $FPASS | sudo -S systemctl daemon-reload
                        echo $FPASS | sudo -S systemctl enable tomcat.service
                        echo $FPASS | sudo -S systemctl restart tomcat.service
                        echo $FPASS | sudo -S systemctl status tomcat.service
                fi
        fi
        rm -rf /tmp/tomcat2.tar.bz2
EOF
}

process $1
        echo "PROCESSO FINALIZADO!!! |--> $1"
