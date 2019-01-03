#!/bin/bash
echo 'Staring init script for PM-UI'

echo 'Installing Node.js and NPM'
sudo apt-get update
sudo apt install curl -y
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
apt install nodejs

echo 'Install nginx'
apt-get install nginx -y

echo 'Extract ui artifact to /var/www/promotions-manager/'
mkdir $ARTIFACTS_PATH/drop
tar -xvf $ARTIFACTS_PATH/promotions-manager-ui.*.tar.gz -C $ARTIFACTS_PATH/drop/
mkdir /var/www/promotions-manager/
tar -xvf $ARTIFACTS_PATH/drop/drop/promotions-manager-ui.*.tar.gz -C /var/www/promotions-manager/

echo 'Configure nginx'
cd /etc/nginx/sites-available/
cp default default.backup

cat << EOF > ./default
server {
	listen $PORT default_server;
	listen [::]:$PORT default_server;
	root /var/www/promotions-manager;
	server_name _;
	index index.html index.htm;
	location /api/ {		
		proxy_pass      http://promotions-manager-api.$DOMAIN_NAME:$API_PROXY_PORT/api/;
	}
}
EOF