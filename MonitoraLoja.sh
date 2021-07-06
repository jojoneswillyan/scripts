#!/bin/bash
#SCRIPT PARA MONITORAR IP OU LOJA NO EXECUTA.SH
#CRIADO POR JONES EM 17-03-2021
who | grep -e "`whoami`"
#whoami=`whoami`
# echo "USER ->" $whoami
# date
HOST=$1
echo -e "\033[1;33mPRESSIONE CTRL+C PARA INTERROMPER  \033[0m"
while sleep 1; do echo $1 | sh /pdv/geraInventario/executa.sh | grep -e "RETORNO 0 | " -e "DT ATUALIZACAO" ;done