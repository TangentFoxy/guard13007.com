#!/bin/bash

set -o errexit   # exit on error

# No prerequisites
#sudo apt-get update && sudo apt-get upgrade -y
#sudo apt-get install wget curl lua5.1 liblua5.1-0-dev zip unzip libreadline-dev libncurses5-dev libpcre3-dev openssl libssl-dev perl make build-essential postgresql nginx -y
#Those should already be installed and probably were mostly only needed for compiling prerequisites of OpenResty/LuaRocks themselves.
sudo luarocks install luacrypto

# No certificates

# Make database
read -p "Enter a password for postgres user: " postgres_password
sudo -u postgres bash -c 'psql -c "ALTER USER postgres WITH PASSWORD '\'$postgres_password\'';" && createdb devguard13007com'

# Assumes you have run lapis-dev-setup.sh from oschecklist/linux

# okay now let's set it up
cp secret.moon.example secret.moon
nano secret.moon        # Put the info needed in there!
#TODO replace that w this script generating it!
git submodule init
git submodule update
moonc .
lapis migrate development

# Do not set up a service
echo "Ready to `lapis server development`"
