#!/bin/bash -x

docker run -d --name vite-db -v vite-data:/var/lib/postgresql/data -p 5432:5432 postgres:9.6 >/dev/null
