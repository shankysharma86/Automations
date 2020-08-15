# GeneralAutomations

---- Elk-stack
     This automation will generate self-signed certificates using OpenSSL, add root cert to trusted list and spin Elasticserch and Kibana containers with SSL        implemented. 
      
      After cloning git repo into local follow below commands
      
     1. Chmod +x ./elkcerts/certgen.sh
     2. sudo bash ./elkcerts/certgen.sh "<mycertpassword>"
