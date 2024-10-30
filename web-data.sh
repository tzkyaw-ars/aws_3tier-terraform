#!/bin/bash

# Update package lists
sudo apt-get update && sudo apt-get upgrade -y

# Install Apache HTTP server
sudo apt-get install -y apache2

# Start Apache service
sudo systemctl start apache2
sudo systemctl enable apache2

# Create a simple index.html file
sudo cat << EOF > /var/www/html/index.html
<html>
  <head>
    <title>My Website</title>
  </head>
  <body>
    <h1>Welcome to my website!</h1>
    <p>This is a simple web page served by Apache on an EC2 instance.</p>
  </body>
</html>
EOF

echo "EC2 instance setup complete. You can now access your website at the instance's public IP address."