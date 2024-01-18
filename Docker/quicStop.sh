docker stop es01-test
docker stop kib01-test

docker network rm elastic
docker rm es01-test
docker rm kib01-test