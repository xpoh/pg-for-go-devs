#! /bin/bash
set -e

(docker stop postgres && docker rm postgres) || true
sudo rm -rf data

docker run \
    -d \
    -p 5432:5432 \
    --name postgres \
    -e POSTGRES_PASSWORD=aswqas \
    -e PGDATA=/var/lib/postgresql/data \
    -v $HOME/pg-for-go-devs/lesson-5/data:/var/lib/postgresql/data \
    -v $HOME/pg-for-go-devs/lesson-5/init:/docker-entrypoint-initdb.d \
    postgres:14