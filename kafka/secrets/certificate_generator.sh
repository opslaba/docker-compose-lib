#!/bin/bash

# default certificate params
COUNTRY="CA"
STATE="BC"
LOCALITY="VAN"
ORGANIZATION="myltd"
ORGANIZATIONAL_UNIT="IT"
COMMON_NAME_CA="CA"
EMAIL="admin@myltd.lab"

# Создаем директории для хранения сертификатов и ключей
mkdir -p ssl/ca/{certs,newcerts,private}
mkdir -p ssl/certs
touch ssl/ca/index.txt
echo 1000 > ssl/ca/serial

# Генерируем ключ и сертификат CA
openssl genrsa -out ssl/ca/private/ca.key.pem 4096
openssl req -config csr.conf -key ssl/ca/private/ca.key.pem -new -x509 -days 3650 -sha256 -extensions v3_ca -out ssl/ca/certs/ca.cert.pem -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME_CA/emailAddress=$EMAIL"
echo "CA сертификат и ключ созданы."

# Создаем серверный ключ и CSR
COMMON_NAME_SERVER="server.local"
openssl genrsa -out ssl/certs/server.key.pem 2048
openssl req -config csr.conf -key ssl/certs/server.key.pem -new -out server.csr.pem -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME_SERVER/emailAddress=$EMAIL"

# Подписываем серверный сертификат с помощью CA
openssl ca -batch -config csr.conf -extensions v3_server -days 825 -notext -md sha256 -in server.csr.pem -out ssl/certs/server.cert.pem
echo "Серверный сертификат и ключ созданы и подписаны."

# Создаем клиентский ключ и CSR
COMMON_NAME_CLIENT="client"
openssl genrsa -out ssl/certs/client.key.pem 2048
openssl req -config csr.conf -key ssl/certs/client.key.pem -new -out client.csr.pem -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORGANIZATIONAL_UNIT/CN=$COMMON_NAME_CLIENT/emailAddress=$EMAIL"

# Подписываем клиентский сертификат с помощью CA
openssl ca -batch -config csr.conf -extensions v3_client -days 825 -notext -md sha256 -in client.csr.pem -out ssl/certs/client.cert.pem
echo "Клиентский сертификат и ключ созданы и подписаны."

# Убираем ненужные файлы
rm server.csr.pem client.csr.pem

echo "Все сертификаты и ключи созданы успешно."
