#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install httpd -y
sudo curl -fsSL https://get.docker.com | sh
sudo systemctl start httpd
sudo systemctl enable httpd

echo "<html><head><title> Apache 2023 Terraform </title> </head><body><h1>Congratulations! YOU DID IT  <header><p> Completed by Mel Foster 07/09/2023 </p></body>! <h1><hr><article>  <p> Welcome Green Team  <header><p> Completed by Mel Foster 07/09/2023 </p></body> You successfully launched an AWS EC2 Instance with a Custom Apache webpage, and completed the WK22 Terraform Objectives! <p>  <header><p> Completed by Mel Foster 07/09/2023 </p></body> </html>" | sudo tee /var/www/html/index.html