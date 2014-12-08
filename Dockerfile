FROM ubuntu:14.04

ENV MYSQL_ROOT_PASSWORD secretpassword

RUN apt-get update \
  && apt-get install -y mysql-server \
  && rm -rf /var/lib/apt/lists/* \
  && /usr/bin/mysqld_safe > /dev/null 2>&1 & \
  && mysql -uroot -e "UPDATE mysql.user SET password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE user='root'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;" \
  && mysqladmin -uroot shutdown

EXPOSE 3306
CMD ["mysqld_safe"]
