#!/usr/bin/env bash

set -e # exit on any failure

sudo docker build -t guard13007/guard13007com:testing .
sudo docker push guard13007/guard13007com:testing
sudo docker-compose up -d
sudo docker-compose logs -f
