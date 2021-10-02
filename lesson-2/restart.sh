#! /bin/bash
set -e

(docker stop postgres && docker rm postgres) || true
sudo rm -rf data

docker run \
    -d \
    -p 5432:5432 \
    --name postgres \
    -e POSTGRES_PASSWORD=P@ssw0rd \
    -e PGDATA=/var/lib/postgresql/data \
    -v $HOME/pg-for-go-devs/lesson-2/data:/var/lib/postgresql/data \
    -v $HOME/pg-for-go-devs/lesson-2/init_2:/docker-entrypoint-initdb.d \
    -v $HOME/pg-for-go-devs/lesson-2/fill_tables:/fill_tables \
    postgres:13.4