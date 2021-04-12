#OS
FROM debian:buster

#install
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get install -y nginx wget curl mariadb-client mariadb-server openssl
RUN apt-get install -y php7.3-fpm php7.3-mysql php7.3-common php7.3-mbstring php7.3-xmlrpc php7.3-soap php7.3-gd php7.3-intl php7.3-cli php7.3-ldap php7.3-zip php7.3-curl

#delete default
RUN rm /etc/nginx/sites-available/default && rm /etc/nginx/sites-enabled/default

#ssl
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:2048 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/heusebio.pem -keyout /etc/nginx/ssl/heusebio.key -subj "/C=RU/ST=Russia/L=Moscow/O=School 21/OU=heusebio/CN=localhost"

RUN mkdir /var/www/heusebio

#wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN mv wordpress /var/www/heusebio/ && rm latest.tar.gz
COPY /srcs/wp-config.php /var/www/heusebio/wordpress

#phpmyadmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.tar.gz
RUN tar -xvzf phpMyAdmin-4.9.5-all-languages.tar.gz
RUN mv phpMyAdmin-4.9.5-all-languages /var/www/heusebio/phpmyadmin
RUN rm phpMyAdmin-4.9.5-all-languages.tar.gz && rm /var/www/heusebio/phpmyadmin/config.sample.inc.php
COPY /srcs/config.inc.php /var/www/heusebio/phpmyadmin

COPY srcs/*.sh srcs/nginx.conf /var/www/

RUN mv /var/www/nginx.conf /etc/nginx/sites-available/site
RUN ln -s /etc/nginx/sites-available/site /etc/nginx/sites-enabled/

RUN chown -R www-data:www-data /var/www/* && chmod -R 755 /var/www/*

EXPOSE 80 443

CMD [ "bash","/var/www/start.sh" ]
