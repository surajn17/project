#!/bin/bash

# Update system packages
sudo apt update

# Install Apache2
sudo apt install -y apache2

# Enable Apache2 modules
sudo a2enmod rewrite
sudo a2enmod headers

# Restart Apache2 service
sudo systemctl restart apache2

# Install PHP and required modules
sudo apt install -y php libapache2-mod-php php-mysql

# Restart Apache2 service
sudo systemctl restart apache2

# Install MySQL Server
sudo apt install -y mysql-server

# Secure MySQL installation
sudo mysql_secure_installation

# Create MySQL database and user for WordPress
sudo mysql -e "CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
sudo mysql -e "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Install Docker
sudo apt install -y docker.io

# Pull and run the official WordPress Docker image
sudo docker run -d --name wordpress -p 80:80 -e WORDPRESS_DB_HOST=localhost -e WORDPRESS_DB_NAME=wordpress -e WORDPRESS_DB_USER=wordpressuser -e WORDPRESS_DB_PASSWORD=password wordpress

# Print the WordPress initial login credentials
echo "WordPress has been deployed successfully!"
echo "To access your WordPress site, visit: http://your_server_ip_address/"
echo "To log in to the WordPress admin dashboard, use the following credentials:"
echo "Username: admin"
echo "Password: $(sudo docker exec wordpress cat /var/www/html/wp-admin/setup-config.php | grep DB_PASSWORD | cut -d \" -f 4)"
