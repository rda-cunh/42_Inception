
# use the official debian bookworm image as a base
FROM debian:bookworm

# expose the default nginx port
EXPOSE 443

# install nginx and openssl
RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl && \
		apt clean && rm -rf /var/lib/apt/lists/*
        # clean apt cache to reduce image size

# set variables for ssl certificate generation (to be set later on an .env file)
ARG	CERT_FOLDER=/etc/nginx/certs/
ARG	CERTIFICATE=/etc/nginx/certs/certificate.crt
ARG	KEY=/etc/nginx/certs/certificate.key
ARG	COUNTRY=PT
ARG	STATE=Porto
ARG	LOCALITY=Porto
ARG	ORGANIZATION=42
ARG	UNIT=42
ARG	COMMON_NAME=login.42.fr

# create the folder for the ssl certificates and generate them
RUN	mkdir -p ${CERT_FOLDER} && \
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-out ${CERTIFICATE} \
	-keyout ${KEY} \
	-subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}"
    # subj flag is used to set the certificate information

# copy the custom nginx configuration file into the container
COPY	conf/nginx.conf	/etc/nginx/
COPY	conf/server.conf	/etc/nginx/conf.d/

# complete server.conf with the .env vars
RUN	echo "\tserver name ${COMMON_NAME};\n\
	\tssl_certificate ${CERTIFICATE};\n\
	\tssl_certificate_key ${KEY};\n\
	}" >> /etc/nginx/conf.d/server.conf

# create the folder for the wordpress files and change its ownership
RUN	mkdir -p /var/www/
RUN	chown -R www-data:www-data /var/www/

# start nginx in the foreground
CMD	["nginx", "-g", "daemon off;"]