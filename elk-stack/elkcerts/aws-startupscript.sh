#!/bin/bash

yum -y install docker git
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
service docker start
cd /opt
git clone https://github.com/shankysharma86/GeneralAutomations.git
cd /opt/GeneralAutomations/elk-stack/elkcerts
chmod +x certgen.sh
bash certgen.sh "<your passphrase for certificate>"
