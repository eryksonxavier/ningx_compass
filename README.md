# Atividade Prática 1 #PB - NOV 2024 | DevSecOps

Este projeto é uma introdução prática ao uso do WSL2 e ao gerenciamento do servidor NGINX. Abrange desde a instalação até a configuração de automações que monitoram o status do servidor.


### Pré-requisitos
- **Sistemas Operacionais Suportados:**  
  - Windows 10  
  - Windows 11
- **WSL2**
- **Distribuição Linux:**  
  - Ubuntu 20.04.6 LTS


## Índice

 1. [Instalação do WSL2](#1-instalação-do-wsl2)
 2. [Instalação da Distribuição Linux Ubuntu 20.04.6 LTS](#2-instalação-da-distribuição-linux-ubuntu-20046-lts)
 3. [Instalação do NGINX](#3-instalação-do-nginx)
 4. [Configurações de permissões e logs](#4-configurações-de-permissões-e-logs)
 5. [Criação do script verificador](#5-criação-do-script-verificador)
 6. [Automatizando a execução do script](#6-automatizando-a-execução-do-script)

## 1. Instalação do WSL2
#### 1.1 Abra Prompt de Comando ou PowerShell com permissões de admnistrador e insira o comando:
```bash
wsl --install
```   
#### 1.2 Verifique se foi instalado corretamente como seguinte comando: 
```bash
wsl -l -v
```
Reinicie a sua máquina após concluir a instalação do WSL2

## 2. Instalação da Distribuição Linux Ubuntu 20.04.6 LTS
#### 2.1 Abra a Microsoft Store e pesquise por Ubuntu 20.04.6 LTS
#### 2.2 Procure por Ubuntu 20.04.6 LTS
![microsoft_store](https://github.com/user-attachments/assets/adc37181-2a49-4b43-bb5c-842d9361469b)

#### 2.3 Adquira e instale a distribuição.
![ubuntu](https://github.com/user-attachments/assets/fb773cc7-1225-4fef-a79d-7d72a096cf99)

## 3. Instalação do NGINX 
#### 3.1 Abra o terminal do Ubuntu 20.04 e configure um usuário.
![terminal_ubuntu](https://github.com/user-attachments/assets/20592a8b-8312-47b8-9f24-56af69b16c22)

#### 3.2 Atualize a instância Ubuntu dentro do wsl2:
```bash
sudo apt update
```  
    
#### 3.3 Faça a instalação do NGINX:
```bash
sudo apt install nginx
```  
    
#### 3.4 Após a instalação, verifique o status do NGINX digitando este comando no terminal:
```bash
sudo systemctl status nginx
```  
![status_active](https://github.com/user-attachments/assets/0b488347-d885-4ada-840d-9c496206570c)

#### 3.5 Se estiver parado,é necessário inicializá-lo:
```bash
sudo systemctl enable nginx
sudo systemctl start nginx
```  
    
#### 3.6 Verifique a porta em que o nginx está:
```bash
sudo ss -tunelp | grep nginx
```  
![porta](https://github.com/user-attachments/assets/45a7b3ee-8811-44bf-89c1-09217324b28e)    
![browser_localhost](https://github.com/user-attachments/assets/bf5ff59d-dec3-4466-91b4-ec27ff0d74a3)
## 4. Configurações de permissões e logs
#### 4.1 Altere a permissão de escrita do diretório /var/log/nginx:
```bash
sudo chmod 755 /var/log/nginx
```  
    
#### 4.2 Crie dois arquivos de logs para saída do script:
```bash
sudo touch /var/log/nginx/status_online.log
sudo touch /var/log/nginx/status_offline.log
```  

#### 4.3 Altere o proprietário dos arquivos:
```bash
sudo chown $user:$user /var/log/nginx/status_online.log
sudo chown $user:$user /var/log/nginx/status_offline.log
```  

Substitua o "$user" pelo nome de seu usuário.
## 5. Criação do script verificador
#### 5.1 Crie um diretório para guardar scripts:
```bash
mkdir scripts
```  
    
#### 5.2 Crie o arquivo script nginx_status_check.sh:
```bash
sudo nano scripts/nginx_status.sh
```  
    
#### 5.3 Utilize esse script para verificar o status do NGINX:
```bash
#!/bin/bash

#Definindo variáveis de saída para arquivos de log no diretório /var/log/nginx/
LOG_ONLINE="/var/log/nginx/status_online.log"
LOG_OFFLINE="/var/log/nginx/status_offline.log"

#Armazena a data e hora atual
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
```

#### 5.4 Dê permissão de execução para o script:
```bash
sudo chmod +x scripts/nginx_status.sh
```

#### 5.5 Execute o script para verificar o status do NGINX.
Script executado com o serviço online:

![script_online](https://github.com/user-attachments/assets/f710d9b5-2513-4f7f-bdff-95c3739e2b86)

Script executado com o serviço offline:

![script_offline](https://github.com/user-attachments/assets/4246016f-856d-40f9-90a7-d30a3395d694)

## 6. Automatizando a execução do script
#### 6.1 Para automatizar a execução do script, utilize o cron:
```bash
crontab -e
```     
#### 6.2 Dentro da crontab, insira esta linha de comando e salve o arquivo para ser executado a cada 5 minutos:
```bash
*/5 * * * * scripts/nginx_status_check.sh
```

Guia prático de como estruturar o crontab:
```bash
# ┌───────────── Minuto (0-59)
# │ ┌───────────── Hora (0-23)
# │ │ ┌───────────── Dia do Mês (1-31)
# │ │ │ ┌───────────── Mês (1-12 ou nomes curtos)
# │ │ │ │ ┌───────────── Dia da Semana (0-7 ou nomes curtos)
# │ │ │ │ │
# │ │ │ │ │
# * * * * * /caminho/para/seu/script.sh
```

#### 6.3 Verifique a saída dos logs:

```bash
cat /var/log/nginx/status_online.log
cat /var/log/nginx/status_offline.log
```

Saída do log de status online:

![log_online](https://github.com/user-attachments/assets/9cd041b3-8598-4dee-9881-050e255f4259)

Saída do log de status offline:

![log_offline](https://github.com/user-attachments/assets/38f9bbeb-ad57-4c70-9577-b6937184f201)

## Conclusão
Seguindo esta documentação, você será capaz de configurar e rodar um servidor NGINX utilizando o WSL2 no Windows, além de criar scripts personalizados para automatizar tarefas e gerenciar permissões e logs.

## Créditos
Projeto desenvolvido como parte da Atividade Prática 1 para #PB - NOV 2024 | DevSecOps.
