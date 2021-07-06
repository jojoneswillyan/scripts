[14:46] Guilherme Cossu Piotto
    #!/bin/bash
# Version: Beta 3
# set -x
FPASS="pdv2002"
d=$(date +%Y-%m-%d)
h=$(date +%H:%M)
#echo "" >> /var/log/zabbix_install.log
#echo "" >> /var/log/zabbix_install.log
> /var/log/zabbix_install.log
echo "Running on $d $h" | tee -a /var/log/zabbix_install.log
echo ""
for i in `cat /root/NTUX/hosts.txt`
do
echo "Checking $i"
timeout 5 zabbix_get -s $i -k agent.version > /dev/null 2> /dev/null
 if [ $? -eq 0 ]
then
echo "IP: $i Installed" | tee -a /var/log/zabbix_install.log
echo "----------------------------------------------------------------"
else
ping -c3 $i> /dev/null 2> /dev/null
 if [ $? -ne 0 ]
then
echo "IP: $i Ping Down" | tee -a /var/log/zabbix_install.log
echo "----------------------------------------------------------------"
else
echo "Installing $i"
process() {
echo "Verificando IP: $i"
	sshpass -p $FPASS rsync -e "ssh -o StrictHostKeyChecking=no" --progress /root/NTUX/zabbix_repository_rd/ pdv@$i:/tmp
	sleep 2
	sshpass -p $FPASS ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ConnectTimeout=10 pdv@$i << EOP
EOP
}
	echo $FPASS | sudo -S bash /tmp/zabbix_repository_rd/zabbix.sh
	echo $FPASS | sudo -S bash zabbix_get -s $i -k agent.version > /dev/null 2> /dev/null
 if [ $? -eq 0 ]
then
	echo "IP: $i Installation successful" | tee -a /var/log/zabbix_install.log
echo "----------------------------------------------------------------"
else
	echo "IP: $i Installation failed, probably couldnt detect linux version." | tee -a /var/log/zabbix_install.log
	echo $FPASS | sudo -S bash zabbix_get -s $i -k agent.version
fi
echo "----------------------------------------------------------------"
else
	echo "IP: $i ssh Failed." | tee -a /var/log/zabbix_install.log
echo "----------------------------------------------------------------"
fi
fi
fi
done
# > /root/NTUX/password.txt
~
~
~
~
