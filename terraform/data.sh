#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

echo "<html><head><title> Apache 2023 Terraform </title> </head><body><h1>Congratulations! YOU DID IT  <header><p> Completed by Mel Foster 07/09/2023 </p></body>! <h1><hr><article>  <p> Welcome Green Team  <header><p> Completed by Mel Foster 07/09/2023 </p></body> You successfully launched an AWS EC2 Instance with a Custom Apache webpage, and completed the WK22 Terraform Objectives! <p>  <header><p> Completed by Mel Foster 07/09/2023 </p></body> </html>" | sudo tee /var/www/html/index.html