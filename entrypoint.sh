#!/bin/bash
set -e

if [ ! -d '/var/lib/mysql/mysql' -a "${1%_safe}" = 'mysqld' ]; then
	
	# These statements _must_ be on individual lines, and _must_ end with
	# semicolons (no line breaks or comments are permitted).
	# TODO proper SQL escaping on ALL the things D:
	TEMP_FILE='/tmp/mysql-first-time.sql'
	cat > "$TEMP_FILE" <<-EOSQL
	  UPDATE mysql.user SET password=PASSWORD('${MYSQL_ROOT_PASSWORD}') WHERE user='root';
		GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
		FLUSH PRIVILEGES;
	EOSQL
	
	set -- "$@" --init-file="$TEMP_FILE"
fi

exec "$@"
