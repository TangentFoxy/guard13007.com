#!/bin/bash

set -o errexit   # exit on error

echo "Run install.sh on the main server first!"
read -p " Press [Enter] to continue, or Ctrl+C to cancel."

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
service dev.guard13007com start
echo "(Don't forget to proxy or pass to port 8155!)"
