#!/bin/bash


#Install Apache

dnf install -y httpd
systemctl start httpd.service
systemctl enable httpd.service

#Install MariaDB

dnf -y install mariadb-server mariadb
systemctl start mariadb
systemctl enable mariadb
mysql -V

#Perform automated mysql_secure_installation

MYPWD="password";
NEWPWD="test";

sudo mysql_secure_installation 2>/dev/null <<MSI

n
y
${MYPWD}
${MYPWD}
y
y
y
y

MSI

#Download PHP

sudo yum install epel-release -y
sudo yum install yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
sudo yum install php php-fpm -y
dnf install php php-mysqlnd php-fpm php-opcache php-curl php-json php-gd php-xml php-mbstring php-zip -y
php -v

#Download Wordpress

cd /var/www/html
wget https://wordpress.org/latest.zip && unzip latest.zip && mv wordpress/* . && rm -rf wordpress
chown -R apache:apache /var/www/html
sudo find /var/www/html -type d -exec chmod 770 {} \;
sudo find /var/www/html -type f -exec chmod 660 {} \;
cp wp-config-sample.php wp-config.php
echo
echo "We will need a few details to set up your Wordpress database: "
echo
read -p "Please enter the database name: " db_name
read -p "Please enter the database username: " db_user
read -p "Please enter the database password: " db_pass
read -p "Please enter the database host: " db_host

echo
echo "Creating database... "
mysql -u root -e "CREATE DATABASE $db_name"
if mysql -u root -e "SHOW DATABASES;" | grep -qe "$db_name"; then
        echo "Database $db_name has been created successfully!"
fi
mysql -u root -e "CREATE USER '$db_user'@'$db_host' IDENTIFIED BY '$db_pass';"
if mysql -u root -e "Select user from mysql.user;" | grep -qe "$db_user"; then
        echo "Database user $db_user  has been registered successfully!"
fi
mysql -u root -e "GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'@'$db_host';"
mysql -u root -e "FLUSH PRIVILEGES;"
echo
echo "Changing Wordpress configuration... "
sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_user/g" wp-config.php
sed -i "s/password_here/$db_pass/g" wp-config.php
sed -i "s/localhost/$db_host/g" wp-config.php


echo
echo "Success!"
echo
echo "Now you can log into your Wordpress Website and set it up!"
echo

