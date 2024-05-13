#!/bin/bash

sudo apt update -y

sudo apt install docker.io -y

sudo usermod -a -G docker $(whoami)

sudo systemctl start docker

sudo docker pull pauloalvares/bubbles_website:latest

sudo docker run --name bubbles_website -d -p 80:80 --restart always pauloalvares/bubbles_website:latest