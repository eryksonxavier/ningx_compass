#!/bin/bash

#Definindo as variáveis para salvar os arquivos de log no diretório /var/log/nginx/
LOG_ONLINE="/var/log/nginx/status_online.log"
LOG_OFFLINE="/var/log/nginx/status_offline.log"

#Armazenamento da data e hora atual
DATA=$(date "+%Y-%m-%d %H:%M:$S")

#Variável do nome do serviço
SERVICO="NGINX"

#Verifica o status do serviço e armazena dentro do arquivo log
if systemctl is-active --quiet nginx; then
	echo "$DATA : [$SERVICO - Online] Serviço em execução." >> $LOG_ONLINE
	echo "NGINX está online"
else
	echo "$DATA : [$SERVICO - Offline] Serviçao fora de execução" >> $LOG_OFFLINE
	echo "NGINX está offline"
fi

