#!/bin/bash

# .env ファイルの読み込み
source .env

sudo apt-get update
sudo apt-get install -y curl nginx

# ElasticSearchのリポジトリファイルが存在し、空でない場合は中身を削除
if [ -s /etc/apt/sources.list.d/elastic-7.x.list ]; then
    sudo truncate -s 0 /etc/apt/sources.list.d/elastic-7.x.list
fi



# Elasticsearchの公開GPGキーをAPTにインポート
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

# ソースリストを追加した後にパッケージリストを更新
sudo apt update

# Elasticsearchサービスの起動の際は最大vmの変更が推奨
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Elasticsearch setup
sudo apt-get install -y elasticsearch
sudo systemctl enable elasticsearch.service

# Kibana setup
sudo apt-get install -y kibana
sudo systemctl enable kibana.service

# Logstash setup
sudo apt-get install -y logstash
sudo systemctl enable logstash.service

# Filebeat setup
sudo apt-get install -y filebeat
sudo filebeat modules enable system
sudo filebeat modules enable nginx
sudo filebeat setup

# Metricbeat setup
sudo apt-get install -y metricbeat
sudo metricbeat modules enable system
sudo metricbeat modules enable nginx
sudo metricbeat modules enable elasticsearch-xpack
sudo metricbeat modules enable kibana-xpack
sudo metricbeat modules enable logstash-xpack
sudo metricbeat setup

# 不要なパッケージの削除
sudo apt autoremove
sudo apt clean
