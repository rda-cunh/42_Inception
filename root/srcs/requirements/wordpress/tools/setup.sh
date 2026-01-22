#!/bin/bash

# change the owner of the wordpress files to www-data user
chown -R www-data:www-data /var/www/inception/

# move the wp-config.php file to the wordpress folder (if not already there)
if [ ! -f /var/www/inception/wp-config.php ]; then
	mv /tmp/wp-config.php /var/www/inception/
fi

# temporary variables to be replaced later with a proper .env file [TO DELETE]
WP_URL=login.42.fr
WP_TITLE=Inception
WP_ADMIN_USER=theroot
WP_ADMIN_PASSWORD=123
WP_ADMIN_EMAIL=theroot@123.com
WP_USER=theuser
WP_PASSWORD=abc
WP_EMAIL=theuser@123.com
WP_ROLE=editor

# dowload the wordpress files
sleep 10
wp --allow-root --path="/var/www/inception/" core download || true

# if files aren't present create install wordpress and set it (if not continue)
if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;

# create a non admin user
if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER;
then
    wp  --allow-root --path="/var/www/inception/" user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=$WP_ROLE
fi;

# start the php server
exec $@

