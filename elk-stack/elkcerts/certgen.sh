#!/bin/bash

# Generate Root Key rootCA.key with 2048
openssl genrsa -passout pass:"$1" -des3 -out rootCA.key 2048

# Generate Root PEM (rootCA.pem) with 1024 days validity.
openssl req -passin pass:"$1" -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=Local Certificate"  -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem

# Add root cert as trusted cert
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        yum -y install ca-certificates
        update-ca-trust force-enable
        cp rootCA.pem /etc/pki/ca-trust/source/anchors/
        update-ca-trust
        #meeting ES requirement
        sysctl -w vm.max_map_count=262144
elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain rootCA.pem
else
        # Unknown.
        echo "Couldn't find desired Operating System. Exiting Now ......"
        exit 1
fi


# Generate ES01 Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost"  -new -sha256 -nodes -out es01.csr -newkey rsa:2048 -keyout es01.key
openssl x509 -req -passin pass:"$1" -in es01.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out es01.crt -days 500 -sha256 -extfile  <(printf "subjectAltName=DNS:localhost,DNS:es01")

# Generate ES02 Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost"  -new -sha256 -nodes -out es02.csr -newkey rsa:2048 -keyout es02.key
openssl x509 -req -passin pass:"$1" -in es02.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out es02.crt -days 500 -sha256 -extfile  <(printf "subjectAltName=DNS:localhost,DNS:es02")

# Generate ES03 Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost"  -new -sha256 -nodes -out es03.csr -newkey rsa:2048 -keyout es03.key
openssl x509 -req -passin pass:"$1" -in es03.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out es03.crt -days 500 -sha256 -extfile  <(printf "subjectAltName=DNS:localhost,DNS:es03")

# Generate Kib01 Cert
openssl req -subj "/C=US/ST=Random/L=Random/O=Global Security/OU=IT Department/CN=localhost"  -new -sha256 -nodes -out kib01.csr -newkey rsa:2048 -keyout kib01.key
openssl x509 -req -passin pass:"$1" -in kib01.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out kib01.crt -days 500 -sha256 -extfile  <(printf "subjectAltName=DNS:localhost,DNS:kib01")

cd ../elk

VERSION="7.8.0" HOSTCERTSDIR="$PWD/../elkcerts" ESCERTSDIR="/usr/share/elasticsearch/config" KIBCERTSDIR="/usr/share/kibana/config" docker-compose up -d
