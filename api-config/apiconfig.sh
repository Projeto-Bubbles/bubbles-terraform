#!/bin/bash

sudo apt update -y

sudo apt install docker.io -y

sudo usermod -a -G docker $(whoami)

sudo systemctl start docker

sudo docker pull pauloalvares/bubbles_api:latest

sudo docker run -it --name bubbles_api -p 8080:8080 --restart always pauloalvares/bubbles_api:latest