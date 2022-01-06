$ docker-compose -f ./docker-compose-infra.yml -p oraksil up

$ docker exec -i oraksil_db_1 sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < ./migrations/up.sql

$ docker-compose -f ./docker-compose-apps.yml -p oraksil up
