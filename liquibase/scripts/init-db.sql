CREATE DATABASE IF NOT EXISTS mydb_local;

CREATE USER IF NOT EXISTS mydb_user_local WITH PASSWORD 'Passw0rd';
GRANT ALL ON DATABASE mydb_local TO mydb_user_local;
