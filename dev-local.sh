#!/bin/bash

set -o errexit   # exit on error

echo "Assuming you have pre-requisites set up locally,"
echo " this will set up and run a dev environment."

openssl genrsa -des3 -out privkey.pem 1024   # I'm pretty sure we shouldn't be using 1024-bit keys...
openssl req -new -key privkey.pem -out server.csr
openssl rsa -in privkey.pem -out privkey.pem
openssl x509 -req -days 365 -in server.csr -signkey privkey.pem -out fullchain.pem
rm server.csr

openssl dhparam -out dhparams.pem 2048
echo "Changing user to postgres..."
echo "Run 'createdb devguard13007com' and then 'exit' !"
sudo -i -u postgres
cp secret.moon.example secret.moon
nano secret.moon   # Put the info needed in there!
moonc .
lapis migrate development

# dev.guard13007.com as a service
echo "[Unit]
Description=dev.guard13007.com server
[Service]
Type=forking
WorkingDirectory=$(pwd)
ExecStart=$(which lapis) server development
ExecReload=$(which lapis) build development
ExecStop=$(which lapis) term
[Install]
WantedBy=multi-user.target" > dev.guard13007com.service
sudo cp ./dev.guard13007com.service /etc/systemd/system/dev.guard13007com.service
sudo systemctl daemon-reload
sudo systemctl enable dev.guard13007com.service
sudo service dev.guard13007com start
echo "(Don't forget to proxy or pass to port 8155!)"
