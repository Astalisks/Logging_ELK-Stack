sudo docker stop es01-test
sudo docker stop kib01-test

sudo docker network rm elastic
sudo docker rm es01-test
sudo docker rm kib01-test