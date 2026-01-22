# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rda-cunh <rda-cunh@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/01/20 19:38:56 by rda-cunh          #+#    #+#              #
#    Updated: 2026/01/22 20:08:34 by rda-cunh         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME		= inception
SRCS		= ./srcs
COMPOSE		= $(SRCS)/docker-compose.yml
HOST_URL	= rda-cunh.42.fr

up:
	mkdir -p ~/data/database
	mkdir -p ~/data/wordpress_files
	sudo hostsed add 127.0.0.1 $(HOST_URL)		# add url to /etc/hosts
	docker compose -p $(NAME) -f $(COMPOSE) up --build || (echo " $(FAIL)" && exit 1)

down:
	sudo hostsed rm 127.0.0.1 $(HOST_URL)		# remove url from /etc/hosts
	docker compose -p $(NAME) down

