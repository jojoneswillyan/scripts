#!/bin/bash

DATA=`date +%Y%m%d`
FPASS="pdv2002";

process() {
        sshpass -p pdv2002 rsync -e "ssh -o StrictHostKeyChecking=no" --progress tomcat2.tar.bz2 tomcat tomcat.service pdv@$1:/tmp/
        sshpass -p pdv2002 ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=4 pdv@$1  << EOF
        TOMCAT_BZ2=\`ls /tmp/tomcat2.tar.bz2 | wc -l\`
        UBUNTU_VER=\`lsb_release -r -s\`

        if [ \$TOMCAT_BZ2 -eq 1 ]; then
                TOMCAT_PID=\`ps ax | grep tomcat | grep -v grep | awk '{print \$1}'\`
                kill -9 \$TOMCAT_PID
                echo $FPASS | sudo -S rm -rfv /server/tomcat

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
                        #echo $FPASS | sudo -S reboot
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

IFS=$'\n'

for next in `cat /pdv/vTomcat/loja.txt`
do
        IFS=' ' eval 'array=($next)'

        process ${array[0]} pdv2002 &

        sleep 5
done

