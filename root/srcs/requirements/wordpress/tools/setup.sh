#!/bin/bash

# change the owner of the wordpress files to www-data user
chown -R www-data:www-data /var/www/inception/

# move the wp-config.php file to the wordpress folder (if not already there)
if [ ! -f /var/www/inception/wp-config.php ]; then
	mv /tmp/wp-config.php /var/www/inception/
fi

# temporary variables to be replaced later with a proper .env file