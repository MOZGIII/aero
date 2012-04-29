#!/bin/bash

[[ $0 != "-bash" ]] && echo "Run this script using \"source $0\"" && exit
[[ ! -d "lib" ]] && echo "Run this script from the root of the project" && return

LOGIN=`whoami`
PORT=8200
PROJECT_ROOT=`pwd`

echo "Creating PostgreSQL database in \"db\""
export LC_ALL=ru_RU.UTF-8
initdb -D db

echo "Running database on port $PORT"
pg_ctl -D db -o "-i -p $PORT" start

echo "Creating user in the database"
echo "CREATE USER worker WITH PASSWORD 'worker' CREATEDB;" | psql -p $PORT template1


echo "Deploying files"

mkdir -p /var/www/cgi-bin/$LOGIN
cd /var/www/cgi-bin/$LOGIN
ln -sf $PROJECT_ROOT/lib aero

mkdir -p /var/www/html/$LOGIN
cd /var/www/html/$LOGIN
ln -sf $PROJECT_ROOT/lib/stylesheets


echo "Updating path to styles"
sed -i s/"<link rel = 'stylesheet' href = '.*' type = 'text\/css'>"/"<link rel = 'stylesheet' href = '$LOGIN\/stylesheets\/aero.css' type = 'text\/css'>"/g $PROJECT_ROOT/lib/templates/layout/header.rb

echo "Updating port in db driver config"
# Меняем в файле $PROJECT_ROOT/lib/db_core/db_driver.rb порт 5432 на мой_уникальный_порт
sed -i "s/PORT = .*/PORT = $PORT/g" $PROJECT_ROOT/lib/db_core/db_driver.rb
cd $PROJECT_ROOT
rake test
chmod 755 ~
chmod 755 $PROJECT_ROOT -R

echo "All done! Now go to http://asrv9-ctx-7.msiu.ru/cgi-bin/$LOGIN/aero/aero.rb"
