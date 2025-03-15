FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY mysql.sh /usr/local/bin/mysql.sh

RUN chmod +x /usr/local/bin/mysql.sh \
&& chown mysql:mysql /usr/local/bin/mysql.sh \
&& chown mysql:mysql /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /run/mysqld \
&& chown -R mysql:mysql /run/mysqld


EXPOSE 3306

CMD ["/usr/local/bin/mysql.sh"]