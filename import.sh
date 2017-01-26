#!/bin/bash

set -o errexit   # exit on error

# Prerequisites
sudo apt-get update
sudo apt-get install wget curl lua5.1 liblua5.1-0-dev zip unzip libreadline-dev libncurses5-dev libpcre3-dev openssl libssl-dev perl make build-essential postgresql nginx -y

# Certificates
# I am assuming the domains have already been pointed to the new IP
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto
mv ./certbot-auto /bin/certbot-auto
certbot-auto certonly --standalone -m paul.liverman.iii@gmail.com -d www.guard13007.com -d guard13007.com

# Import database
# Assuming a guard13007com.pgsql file exists here...
echo "Changing user to postgres..."
echo "Run 'psql', enter the following (using a real password of course):"
echo "ALTER USER postgres WITH PASSWORD 'password';"
echo "\q"
echo "Then run 'createdb guard13007com'"
echo "And finally 'psql guard13007com < /path/to/guard13007com.pgsql'"
sudo -i -u postgres

# OpenResty
cd ..
OVER=1.11.2.2
wget https://openresty.org/download/openresty-$OVER.tar.gz
tar xvf openresty-$OVER.tar.gz
cd openresty-$OVER
./configure
make
sudo make install
cd ..

# LuaRocks
LVER=2.4.1
wget https://keplerproject.github.io/luarocks/releases/luarocks-$LVER.tar.gz
tar xvf luarocks-$LVER.tar.gz
cd luarocks-$LVER
./configure
make build
sudo make install
# some rocks
sudo luarocks install lapis
sudo luarocks install moonscript
sudo luarocks install bcrypt

# cleanup
cd ..
rm -rf openresty*
rm -rf luarocks*

# okay now let's set it up
cd guard13007.com
openssl dhparam -out dhparams.pem 2048
cp ./dhparams.pem ../   # I use same values between here and other server stuff on the same host
cp secret.moon.example secret.moon
nano secret.moon        # Put the info needed in there!
git submodule init
git submodule update
moonc .
lapis migrate production

# guard13007.com as a service
echo "[Unit]
Description=guard13007.com server

[Service]
Type=forking
WorkingDirectory=$(pwd)
ExecStart=$(which lapis) server production
ExecReload=$(which lapis) build production
ExecStop=$(which lapis) term

[Install]
WantedBy=multi-user.target" > guard13007com.service
sudo cp ./guard13007com.service /etc/systemd/system/guard13007com.service
sudo systemctl daemon-reload
sudo systemctl enable guard13007com.service
service guard13007com start
echo "(Don't forget to proxy or pass to port 8150!)"
