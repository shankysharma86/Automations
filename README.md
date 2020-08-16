# GeneralAutomations

-- Elk-stack:
     This automation will generate self-signed certificates for localhost using OpenSSL, add root cert to the trusted list and spin Elasticserch and Kibana containers with SSL implemented. Certgen.sh script is made to work with MacOS as well as Amazon linux OS.
      
      After cloning git repo into local follow below commands
      
     1. Chmod +x ./elkcerts/certgen.sh
     2. sudo bash ./elkcerts/certgen.sh "<mycertpassword>"
