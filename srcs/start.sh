#!/bin/bash
service mysql start
service php7.3-fpm start
service nginx start
/var/www/my_sql.sh
bash
