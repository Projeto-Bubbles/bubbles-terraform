#!/bin/bash

sudo apt update -y

sudo apt install docker.io -y

sudo usermod -a -G docker $(whoami)

sudo systemctl start docker

sudo docker pull pauloalvares/bubbles_website:v1.0

sudo docker run --name front -d -p 80:80 pauloalvares/bubbles_website:v1.0