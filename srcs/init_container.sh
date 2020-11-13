service mysql start

# Permisos
chown -R www-data /var/www/*
chmod -R 755 /var/www/*

# Generar la carpeta del sitio web
mkdir /var/www/misitioweb && touch /var/www/misitioweb/index.php
echo "<?php phpinfo(); ?>" >> /var/www/misitioweb/index.php
mv ./tmp/index.html /var/www/misitioweb/index.html
mv ./tmp/index.php /var/www/misitioweb/index.php

# SSL
mkdir /etc/nginx/ssl
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/misitioweb.pem -keyout /etc/nginx/ssl/misitioweb.key -subj "/C=ES/ST=Madrid/L=Madrid/O=42 Madrid/OU=pdiaz-pa/CN=misitioweb"

# Configuracion de NGINX
#mv ./tmp/nginx-conf /etc/nginx/sites-available/localhost
mv ./tmp/nginx-conf /etc/nginx/sites-available/misitioweb
ln -s /etc/nginx/sites-available/misitioweb /etc/nginx/sites-enabled/misitioweb
rm -rf /etc/nginx/sites-enabled/default

# Configuracion de MYSQL
echo "CREATE DATABASE wordpress;" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;" | mysql -u root --skip-password
echo "update mysql.user set plugin='mysql_native_password' where user='root';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

# DL phpmyadmin
mkdir /var/www/misitioweb/phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
tar -xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz --strip-components 1 -C /var/www/misitioweb/phpmyadmin
mv ./tmp/phpmyadmin.inc.php /var/www/misitioweb/phpmyadmin/config.inc.php

# DL wordpress
cd /tmp/
wget -c https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/ /var/www/misitioweb
mv /tmp/wp-config.php /var/www/misitioweb/wordpress

service php7.3-fpm start
service nginx start
bash
