
# use the official debian bookworm image as a base
FROM debian:bookworm

# expose the default wordpress port
EXPOSE 9000

# set a variable to use the php path in the dockerfile
ARG		PHPPATH=/etc/php/8.1/fpm

# install php-fpm and the php-mysql extension
RUN		apt update && apt upgrade -y && \
        apt install --no-install-recommends --no-install-suggests -y \
		ca-certificates \
		php8.1-fpm \
		php8.1-mysql \
		wget \
		tar && \
		apt clean && rm -rf /var/lib/apt/lists/*
        # clean apt cache to reduce image size

# After the php installation we need to stop it to change the configuration files
RUN		service php8.1-fpm stop

# copy the custom php configuration files into the container
COPY	conf/www.conf ${PHPPATH}/pool.d/

RUN		sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini && \
		sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/pool.d/www.conf

# download and install wp-cli (wordpress command line interface)
RUN	wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# create the necessary folders for php-fpm and wordpress
RUN		mkdir -p /run/php/ && \
		mkdir -p /var/run/php/ && \
		mkdir -p /var/www/inception/

# handle unix permissions for wordpress folder (because php and wordpress will not run as root)
RUN		chown -R www-data:www-data /var/www/inception/

# copy the wp-config.php and the setup script to the container and change its permissions
COPY	conf/wp-config.php /tmp/

COPY	tools/setup.sh /bin/
RUN		chmod +x /bin/setup.sh

# execute the setup script then start the php server / --nodaemonize option to avoid php-fpm to run in background
CMD	["setup.sh", "php-fpm8.1", "--nodaemonize"]