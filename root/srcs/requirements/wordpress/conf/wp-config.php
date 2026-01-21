<?php

/* The base configuration for WordPress */
/* Replace later with the actual values from the .env file */

define( 'DB_NAME', getenv('thedatabase') );
define( 'DB_USER', getenv('theuser') );
define( 'DB_PASSWORD', getenv('abc') );
define( 'DB_HOST', getenv('mariadb') );
define( 'WP_HOME', getenv('https://login.42.fr') );
define( 'WP_SITEURL', getenv('https://login.42.fr') );