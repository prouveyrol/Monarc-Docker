#!/bin/bash
DB_USR="$1"
DB_PASS="$2"
DB_HOST="$3"

#Initializing databases
mysql -h $DB_HOST -u $DB_USR -p$DB_PASS monarc_common < MonarcAppFO/db-bootstrap/monarc_structure.sql
mysql -h $DB_HOST -u $DB_USR -p$DB_PASS monarc_common < MonarcAppFO/db-bootstrap/monarc_data.sql

#Create initial user
#Requires local db access + php installed, should be run using docker, see ./rundocker.sh
php ./vendor/robmorgan/phinx/bin/phinx seed:run -c ./module/Monarc/FrontOffice/migrations/phinx.php
