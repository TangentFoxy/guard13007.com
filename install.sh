#!/bin/bash

set -o errexit

install_dir=$(pwd)
read -p "Enter your email address (for certbot-auto): " email
read -p "Enter the domain name that will be used (for certbot-auto): " domain
read -p "Enter a password for the postgres user: " postgres_password

# Prerequisites
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install wget curl lua5.1 liblua5.1-0-dev zip unzip libreadline-dev libncurses5-dev libpcre3-dev openssl libssl-dev perl make build-essential postgresql nginx -y

# Certificates
# assuming domains have already been pointed to the IP
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto
sudo mv ./certbot-auto /bin/certbot-auto
sudo nginx -s stop
sudo certbot-auto certonly --standalone --agree-tos -m $email -d $domain
# -d dev.$domain
sudo nginx

# Database
sudo -u postgres bash -c 'psql -c "ALTER USER postgres WITH PASSWORD '\'$postgres_password\'';" && createdb fursimile'

# OpenResty
cd ..
OVER=1.13.6.1
wget https://openresty.org/download/openresty-$OVER.tar.gz
tar xvf openresty-$OVER.tar.gz
cd openresty-$OVER
./configure
make
sudo make install

# LuaRocks
cd ..
LVER=2.4.1
wget https://keplerproject.github.io/luarocks/releases/luarocks-$LVER.tar.gz
tar xvf luarocks-$LVER.tar.gz
cd luarocks-$LVER
./configure
make build
sudo make install

# rocks!
cd ..
sudo luarocks install luacrypto
sudo luarocks install lapis
sudo luarocks install moonscript
sudo luarocks install bcrypt
sudo luarocks install lua-cjson

# cleanup (sudo just in case permissions are weird)
sudo rm -rf openresty*
sudo rm -rf luarocks*

# finish set-up
cd $install_dir
echo "{
  sql_password: '$postgres_password'
  session_secret: '$(cat /dev/urandom | head -c 12 | base64)'
  domain_name: '$domain'
}" > ./secret.moon
moonc . # works here because *_temp/ directories don't exist
lapis migrate production

# As-a-Service
echo "[Unit]
Description=$domain (fursimile) server

[Service]
User=www-data
Type=forking
WorkingDirectory=$install_dir
ExecStart=$(which lapis) server production
ExecReload=$(which lapis) build production
ExecStop=$(which lapis) term

[Install]
WantedBy=multi-user.target" > ./fursimile.service
sudo cp ./fursimile.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable fursimile.service
sudo service fursimile start

# configure proxy
echo "user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
	worker_connections 768;
}

http {
	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	server_tokens off;

	include /etc/nginx/mime.types;
	default_type application/octet-stream;

	ssl_certificate /etc/letsencrypt/live/$domain/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/$domain/privkey.pem;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
	ssl_prefer_server_ciphers on;
	ssl_ciphers \"EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH\";
	ssl_ecdh_curve secp384r1;         # nginx >= 1.1.0
	ssl_session_cache shared:SSL:10m;
	ssl_session_tickets off;          # nginx >= 1.5.9
	ssl_stapling on;                  # nginx >= 1.3.7
	ssl_stapling_verify on;           # nginx >= 1.3.7
	ssl_dhparam /srv/dhparams.pem;

	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;

	gzip on;
	gzip_disable \"msie6\";

  add_header Strict-Transport-Security \"max-age=63072000; includeSubDomains; preload\";
  add_header X-Frame-Options DENY;
  add_header X-Content-Type-Options nosniff;

	# requests without domain name
	server {
		listen 80 default_server;
		listen 443 default_server;

		return 404;
	}

	# HTTP -> HTTPS
	server {
		listen 80;
		server_name _;
		return 301 https://\$host\$request_uri;
	}

	include $(pwd)/fursimile-proxy.conf;
}" > ./nginx-proxy.conf
sudo mv ./nginx-proxy.conf /etc/nginx/nginx.conf
echo "server {
  listen 443 ssl;
  server_name $domain;
  location / {
    proxy_pass http://$domain:9450;
  }
}" > ./fursimile-proxy.conf
openssl dhparam -out /srv/dhparams.pem 2048
sudo nginx -s reload
