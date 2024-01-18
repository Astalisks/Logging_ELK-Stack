#!/bin/bash

# Elasticsearchのアンインストール
echo "Elasticsearchをアンインストールしています..."
sudo systemctl stop elasticsearch.service
sudo apt-get remove --purge -y elasticsearch
sudo rm -rf /etc/elasticsearch  # 設定ファイルの削除
sudo rm -rf /var/lib/elasticsearch
sudo rm -rf /var/log/elasticsearch
echo "Elasticsearchのアンインストールが完了しました。"

# Kibanaのアンインストール
echo "Kibanaをアンインストールしています..."
sudo systemctl stop kibana.service
sudo apt-get remove --purge -y kibana
sudo rm -rf /etc/kibana  # 設定ファイルの削除
sudo rm -rf /var/lib/kibana
sudo rm -rf /var/log/kibana
echo "Kibanaのアンインストールが完了しました。"

# Logstashのアンインストール
echo "Logstashをアンインストールしています..."
sudo systemctl stop logstash.service
sudo apt-get remove --purge -y logstash
sudo rm -rf /etc/logstash  # 設定ファイルの削除
sudo rm -rf /var/lib/logstash
sudo rm -rf /var/log/logstash
echo "Logstashのアンインストールが完了しました。"

# Filebeatのアンインストール
echo "Filebeatをアンインストールしています..."
sudo systemctl stop filebeat
sudo apt-get remove --purge -y filebeat
sudo rm -rf /etc/filebeat  # 設定ファイルの削除
sudo rm -rf /var/lib/filebeat
sudo rm -rf /var/log/filebeat
echo "Filebeatのアンインストールが完了しました。"

# Metricbeatのアンインストール
echo "Metricbeatをアンインストールしています..."
sudo systemctl stop metricbeat
sudo apt-get remove --purge -y metricbeat
sudo rm -rf /etc/metricbeat  # 設定ファイルの削除
sudo rm -rf /var/lib/metricbeat
sudo rm -rf /var/log/metricbeat
echo "Metricbeatのアンインストールが完了しました。"

# すべての不要なパッケージと依存関係の削除
echo "不要なパッケージと依存関係を削除しています..."
sudo apt autoremove -y
sudo apt clean -y
echo "クリーンアップが完了しました。"

# ここにエラーハンドリングとログ記録のコードを追加する
