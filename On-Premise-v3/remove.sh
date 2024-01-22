#!/bin/bash

# サービスの停止
source ./stop.sh

# Elasticsearch のアンインストール
sudo apt-get remove --purge -y elasticsearch

# Kibana のアンインストール
sudo apt-get remove --purge -y kibana

# Logstash のアンインストール
sudo apt-get remove --purge -y logstash

# Filebeat のアンインストール
sudo apt-get remove --purge -y filebeat

# Metricbeat のアンインストール
sudo apt-get remove --purge -y metricbeat

# Packetbeat のアンインストール
sudo apt-get remove --purge -y packetbeat

# 不要なパッケージの削除
sudo apt autoremove -y
sudo apt clean -y

# echo "All services have been removed and cleaned up."
