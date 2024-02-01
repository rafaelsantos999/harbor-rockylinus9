#!/bin/bash

echo "Adentrando na pasta HOME"
cd /home/ || exit

echo "Baixando o instalador do Harbor"
# Adicionando sudo para garantir permissão ou certifique-se de estar em um diretório onde o usuário atual tem permissão de escrita
sudo wget https://github.com/goharbor/harbor/releases/download/v2.10.0/harbor-offline-installer-v2.10.0.tgz

echo "Descompactando o instalador"
# Usando sudo para garantir permissões
sudo tar xzvf harbor-offline-installer-v2.10.0.tgz || exit
sudo rm -f harbor-offline-installer-v2.10.0.tgz

echo "Entrando na pasta do Harbor"
# Certificando-se de que o diretório existe antes de tentar acessá-lo
cd /home/harbor/ || exit

echo "Gerando certificado"
sudo mkdir -p /data/cert/
cd /data/cert/ || exit

echo "Gerando uma chave privada de certificado CA"
sudo openssl genrsa -out ca.key 4096

echo "Criando um certificado de CA"
sudo openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=RafaelLTDA/OU=TI/CN=harborroc01" \
 -key ca.key \
 -out ca.crt

echo "Gerando um arquivo de extensão x509 v3"
# Usando sudo para garantir que o arquivo pode ser criado
sudo bash -c 'cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=harborroc01
DNS.2=RafaelLTDA
EOF'

echo "Gerando um certificado para o host Harbor usando o arquivo v3.ext"
sudo openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in ca.csr \
    -out ca.crt

echo "Retornando para a pasta do Harbor"
cd /home/harbor/ || exit

### EM ANDAMENTO ####
