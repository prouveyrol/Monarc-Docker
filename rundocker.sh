docker run -d -p 8080:80 -e db_host=<hostname> -e db_common_name=<db_common_name> -e db_cli_name=<db_cli_name> -e db_user=<db_user> -e db_pass=<db_pass> $1
