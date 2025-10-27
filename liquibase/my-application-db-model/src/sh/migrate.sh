#!/usr/bin/env bash

is_empty() { ! [[ $1 ]]; }
is_empty ${SQL_HOST} && echo "env variable SQL_HOST is empty, please set SQL_HOST" && exit 1
is_empty ${SQL_PORT} && echo "env variable SQL_PORT is empty, please set SQL_PORT" && exit 1
is_empty ${SQL_DATABASE_NAME} && echo "env variable SQL_DATABASE_NAME is empty, please set SQL_DATABASE_NAME" && exit 1
is_empty ${SQL_USERNAME} && echo "env variable SQL_USERNAME is empty, please set SQL_USERNAME" && exit 1
is_empty ${SQL_PASSWORD} && echo "env variable SQL_PASSWORD is empty, please set SQL_PASSWORD" && exit 1

CONNECTION_STRING="jdbc:postgresql://${SQL_HOST}:${SQL_PORT}/${SQL_DATABASE_NAME}"

if [ is_empty ${LOG_LEVEL} ]; then
  LOG_LEVEL=info
fi
echo "Attempting connect TO PostgreSQL"

docker-entrypoint.sh --logLevel=${LOG_LEVEL} --url=${CONNECTION_STRING} --username=${SQL_USERNAME} --password=${SQL_PASSWORD} --classpath=/app/config/db/changelog --changeLogFile=changelog-root.xml update
