#!/bin/bash

# Elasticsearchのアンインストール
sudo systemctl stop elasticsearch.service
sudo apt-get remove --purge -y elasticsearch

# Kibanaのアンインストール
sudo systemctl stop kibana.service
sudo apt-get remove --purge -y kibana

# Logstashのアンインストール
sudo systemctl stop logstash.service
sudo apt-get remove --purge -y logstash

# Filebeatのアンインストール
sudo systemctl stop filebeat
sudo apt-get remove --purge -y filebeat

# Metricbeatのアンインストール
sudo systemctl stop metricbeat
sudo apt-get remove --purge -y metricbeat

# すべての不要なパッケージと依存関係の削除
sudo apt autoremove -y
sudo apt clean
