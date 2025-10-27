#!/bin/bash

set -e

if [ ! -d "/tmp/data" ]
then
  mkdir /tmp/data
  #generate certificates for inter-node communication
  cockroach cert create-ca --certs-dir=/tmp/certs --ca-key=/tmp/certs/ca.key
  cockroach cert create-node localhost cockroachdb --certs-dir=/tmp/certs --ca-key=/tmp/certs/ca.key
  #generate client certificate for root user (used for internal sql client when setting up db)
  cockroach cert create-client root --certs-dir=/tmp/certs --ca-key=/tmp/certs/ca.key
  cockroach start-single-node --certs-dir=/tmp/certs --store=/tmp/data --disable-cluster-name-verification --accept-sql-without-tls --pid-file=/tmp/pid --background
  cat /script/init-db.sql | ./cockroach sql --certs-dir=/tmp/certs

  kill $(cat /tmp/pid) && \

  echo "Sleeping 10 to allow db to gracefully shutdown" && \
  sleep 10
fi

cockroach start-single-node \
          --insecure \
          --store=/tmp/data \
          --disable-cluster-name-verification \
          --accept-sql-without-tls \
          --pid-file=/tmp/pid \
          --advertise-addr=:26257 \
          --sql-addr=:26357 \
          --http-addr=:8181
