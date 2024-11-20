#!/usr/bin/env bash

if command -v docker-compose >/dev/null; then
  cmd="docker-compose"
elif command -v docker compose >/dev/null; then
  cmd="docker compose"
else
  echo "Docker compose missed..."
  exit 1
fi

if [[ $1 == "up" ]]
then
    echo "Docker compose deploy"
    ./local_secrets.sh --kafka-root local-kafka --kms-root kms --service-root service
    $cmd up -d
else
    if [[ $1 == "down" ]]
    then
        echo "Docker compose destroy"
        $cmd down --remove-orphans
    fi
fi