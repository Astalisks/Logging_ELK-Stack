#!/bin/bash

# Elasticsearchの公開GPGキーをAPTにインポート
sudo apt update
sudo apt install curl
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
# Elasticソースリストをsources.list.dに追加
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
# Elasticsearchサービスの起動の際は最大vmの変更が推奨
sudo sysctl -w vm.max_map_count=262144
# nginxサーバーを用意
sudo apt install nginx
# Elasticsearch setup
sudo apt install elasticsearch
sudo systemctl enable elasticsearch.service
# Kibana setup
sudo apt install kibana
sudo systemctl enable kibana.service
# Logstash setup
sudo apt clean
sudo apt install logstash
sudo systemctl enable logstash.service
# Filebeat setup
sudo apt install filebeat
sudo filebeat modules enable system
sudo filebeat modules enable nginx
sudo filebeat setup
# Metricbeat setup
sudo apt install metricbeat
sudo metricbeat modules enable system
sudo metricbeat modules enable nginx
sudo metricbeat modules enable elasticsearch-xpack
sudo metricbeat modules enable kibana-xpack
sudo metricbeat modules enable logstash-xpack
sudo metricbeat setup
sudo apt autoremove
sudo systemctl daemon-reload