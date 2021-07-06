#!/bin/bash
# EXECUTA.SH EM MASSA
read -p "NOME DO ARQUIVO PARA SALVAR:" ARQ
#rm -rfv /pdv/geraInventario/bin/LOG
#LOG=LOG
#touch /pdv/geraInventario/bin/LOG
date
cat lojas.txt | sort -n |  while read output
do
        ping -c 1 "$output" &> /dev/null
        if [ $? -eq 0 ]; then
        echo "IP $output ON-LINE"
        echo $output | bash /pdv/geraInventario/executa.sh | grep -e "DT ATUALIZACAO" -e "RETORNO 0 | "  &>> $ARQ
else
        echo "IP $output OFF-LINE" &>>IPOFF.txt
        fi
        chmod -R 777 lojas.txt
        chmod -R 777 $ARQ
        chmod -R 777 IPOFF.txt
done
