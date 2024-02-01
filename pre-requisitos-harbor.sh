#!/bin/bash

LOG_FILE="install.log"

### Instalação do Docker
docker-install() {
    echo "Verificando se o Docker já está instalado..." | tee -a $LOG_FILE
    if docker --version &> /dev/null; then
        echo "Docker já está instalado. Versão atual: $(docker --version)" | tee -a $LOG_FILE
    else
        echo "Docker não está instalado. Iniciando a instalação..." | tee -a $LOG_FILE
        echo "Atualizando o banco de dados de pacotes..." | tee -a $LOG_FILE
        sudo dnf check-update | tee -a $LOG_FILE
        
        echo "Adicionando o repositório oficial do Docker..." | tee -a $LOG_FILE
        sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo | tee -a $LOG_FILE
        
        echo "Instalando o Docker CE (Community Edition)..." | tee -a $LOG_FILE
        sudo dnf install -y docker-ce docker-ce-cli containerd.io | tee -a $LOG_FILE
        
        echo "Iniciando o serviço Docker..." | tee -a $LOG_FILE
        sudo systemctl start docker | tee -a $LOG_FILE
        
        echo "Configurando o Docker para iniciar automaticamente após o reboot..." | tee -a $LOG_FILE
        sudo systemctl enable docker | tee -a $LOG_FILE
        
        echo "Docker instalado com sucesso. Versão instalada: $(docker --version)" | tee -a $LOG_FILE
    fi
    echo "" | tee -a $LOG_FILE  # Quebra de linha para melhorar a leitura
}

### Instalação do Docker-Compose
docker-compose-install() {
    echo "Verificando se o Docker Compose já está instalado..." | tee -a $LOG_FILE
    if docker compose version &> /dev/null; then
        echo "Docker Compose já está instalado. Versão atual: $(docker compose version)" | tee -a $LOG_FILE
    else
        echo "Docker Compose não está instalado. Iniciando a instalação..." | tee -a $LOG_FILE
        echo "Atualizando o banco de dados de pacotes..." | tee -a $LOG_FILE
        sudo dnf check-update | tee -a $LOG_FILE
        
        echo "Adicionando o repositório oficial do Docker, se ainda não estiver presente..." | tee -a $LOG_FILE
        sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo | tee -a $LOG_FILE
        
        echo "Instalando o Docker Compose..." | tee -a $LOG_FILE
        sudo dnf install -y docker-compose-plugin | tee -a $LOG_FILE
        
        echo "Docker Compose instalado com sucesso. Versão instalada: $(docker compose version)" | tee -a $LOG_FILE
    fi
    echo "" | tee -a $LOG_FILE  # Quebra de linha para melhorar a leitura
}

### Verificar e instalar OpenSSL, se necessário
check_and_install_openssl() {
    echo "Verificando a instalação do OpenSSL..." | tee -a $LOG_FILE
    if openssl version &> /dev/null; then
        echo "OpenSSL já está instalado. Versão atual: $(openssl version)" | tee -a $LOG_FILE
    else
        echo "OpenSSL não está instalado. Iniciando a instalação..." | tee -a $LOG_FILE
        
        echo "Atualizando o banco de dados de pacotes..." | tee -a $LOG_FILE
        sudo dnf update -y | tee -a $LOG_FILE
        
        echo "Instalando o OpenSSL..." | tee -a $LOG_FILE
        sudo dnf install -y openssl | tee -a $LOG_FILE
        
        echo "OpenSSL instalado com sucesso. Versão instalada: $(openssl version)" | tee -a $LOG_FILE
    fi
    echo "" | tee -a $LOG_FILE  # Quebra de linha para melhorar a leitura
}

### Execução sequencial das funções de instalação
docker-install
docker-compose-install
check_and_install_openssl
