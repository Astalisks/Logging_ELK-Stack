#!/bin/bash

# .env ファイルの読み込み
source .env

sudo apt-get update
sudo apt-get install -y curl nginx

# Elasticsearchの公開GPGキーをAPTにインポート
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

# ソースリストを追加した後にパッケージリストを更新
sudo apt update

# Elasticsearchサービスの起動の際は最大vmの変更が推奨
sudo sysctl -w vm.max_map_count=262144

# Elasticsearch setup
sudo apt-get install -y elasticsearch=$ELKSTACK_VERSION
sudo systemctl enable elasticsearch.service

# Kibana setup
sudo apt-get install -y kibana=$ELKSTACK_VERSION
sudo systemctl enable kibana.service

# Logstash setup
sudo apt-get install -y logstash=$ELKSTACK_VERSION
sudo systemctl enable logstash.service

# Filebeat setup
sudo apt-get install -y filebeat=$ELKSTACK_VERSION
sudo filebeat modules enable system
sudo filebeat modules enable nginx
sudo filebeat setup

# Metricbeat setup
sudo apt-get install -y metricbeat=$ELKSTACK_VERSION
sudo metricbeat modules enable system
sudo metricbeat modules enable nginx
sudo metricbeat modules enable elasticsearch-xpack
sudo metricbeat modules enable kibana-xpack
sudo metricbeat modules enable logstash-xpack
sudo metricbeat setup

# 不要なパッケージの削除
sudo apt autoremove
sudo apt clean
