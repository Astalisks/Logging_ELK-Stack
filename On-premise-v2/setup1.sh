#!/bin/bash

# .env ファイルの読み込み
. .env

sudo apt-get update
sudo apt-get install -y curl nginx

# Elasticsearchの公開GPGキーをAPTにインポート
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt install -y apt-transport-https

# ソースリストにElasticsearchのリポジトリを追加
sudo add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"

# /etc/hosts に追加するエントリー
echo "10.252.0.206 node-1" >> /etc/hosts
echo "10.252.0.208 node-2" >> /etc/hosts
echo "10.252.0.234 node-3" >> /etc/hosts

# ソースリストを追加した後にパッケージリストを更新
sudo apt update

# Elasticsearchサービスの起動の際は最大vmの変更が推奨
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Elasticsearch setup
sudo apt-get install -y elasticsearch
# Elasticsearchの設定ファイルを編集
sudo sed -i 's/#cluster.name: my-application/cluster.name: my-cluster01/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#node.name: node-1/node.name: node-1/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#discovery.seed_hosts: \["host1", "host2"\]/discovery.seed_hosts: \["node-1", "node-2", "node-3"\]/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#cluster.initial_master_nodes: \["node-1", "node-2"\]/cluster.initial_master_nodes: \["node-1", "node-2", "node-3"\]/' /etc/elasticsearch/elasticsearch.yml
# 起動
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
# sudo metricbeat modules enable logstash-xpack
sudo metricbeat setup

# 不要なパッケージの削除
sudo apt autoremove
sudo apt clean
