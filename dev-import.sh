#!/bin/bash

set -o errexit   # exit on error

echo "Assuming the main server was set up and running adjacent to this,"
echo " this will set up and run a dev environment."

cp ../dhparams.pem ./dhparams.pem
certbot-auto certonly --standalone -m paul.liverman.iii@gmail.com -d www.guard13007.com -d guard13007.com -d dev.guard13007.com

echo "Changing user to postgres..."
echo "Run 'createdb devguard13007com'"
echo "And then 'psql devguard13007com < /path/to/devguard13007com.pgsql'"
echo "And finally 'exit'"
sudo -i -u postgres
cp secret.moon.example secret.moon
nano secret.moon   # Put the info needed in there!
git submodule init
git submodule update
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
