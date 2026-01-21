# this dockerfile is used to build the image for the mariadb container

# use the official debian bookworm image as a base
FROM debian:bookworm

# install mariadb server
RUN apt update && apt upgrade -y && \
    apt install -y mariadb-server && \
    apt clean && rm -rf /var/lib/apt/lists/*    
    # clean apt cache to reduce image size

# expose the default mariadb port
EXPOSE 3306

# copy the mariadb configuration file into the container
COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# copy the setup script into the container and make it executable
COPY	tools/setup.sh /bin/setup.sh
RUN     chmod +x /bin/setup.sh

# set the entrypoint to start mariadb server
ENTRYPOINT ["/bin/setup.sh", "mysqld_safe"]