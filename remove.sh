#!/bin/bash

# Elasticsearchのアンインストール
sudo systemctl stop elasticsearch.service
sudo apt-get remove --purge -y elasticsearch
sudo rm -rf /var/lib/elasticsearch
sudo rm -rf /var/log/elasticsearch

# Kibanaのアンインストール
sudo systemctl stop kibana.service
sudo apt-get remove --purge -y kibana
sudo rm -rf /var/lib/kibana
sudo rm -rf /var/log/kibana

# Logstashのアンインストール
sudo systemctl stop logstash.service
sudo apt-get remove --purge -y logstash
sudo rm -rf /var/lib/logstash
sudo rm -rf /var/log/logstash

# Filebeatのアンインストール
sudo systemctl stop filebeat
sudo apt-get remove --purge -y filebeat
sudo rm -rf /var/lib/filebeat
sudo rm -rf /var/log/filebeat

# Metricbeatのアンインストール
sudo systemctl stop metricbeat
sudo apt-get remove --purge -y metricbeat
sudo rm -rf /var/lib/metricbeat
sudo rm -rf /var/log/metricbeat

# すべての不要なパッケージと依存関係の削除
sudo apt autoremove -y
sudo apt clean
