#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install apache2 -y
sudo curl -fsSL https://get.docker.com | sh
sudo systemctl start apache2
sudo systemctl enable apache2
sudo apt install mysql-client -y
