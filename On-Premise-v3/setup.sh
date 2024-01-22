#!/bin/bash

sudo apt-get update
sudo apt-get install -y curl nginx

# Elasticsearchの公開GPGキーをAPTにインポート
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install -y apt-transport-https
sudo apt-get update
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

sudo apt-get update

# Elasticsearch, Kibana, Logstash, Filebeat, Metricbeat, Packetbeatのインストール
sudo apt-get install -y elasticsearch kibana logstash filebeat metricbeat packetbeat

# 不要なパッケージの削除
sudo apt autoremove -y
sudo apt clean -y
