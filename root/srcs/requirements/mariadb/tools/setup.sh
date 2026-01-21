#!/bin/sh

# Start MariaDB
service mariadb start

# REMOVE THIS LATER AFTER HAVING A PROPER .ENV FILE
DB_NAME=thedatabase
DB_USER=theuser
DB_PASSWORD=abc
DB_PASS_ROOT=123

# Create the database and users with appropriate privileges
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
EOF

# Give some time to ensure all commands are executed before stopping the service
sleep 5
service mariadb stop

# Execute any additional commands passed to the script
exec $@
