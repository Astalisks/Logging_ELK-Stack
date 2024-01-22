#!/bin/bash

# vm.max_map_countの設定
./update_vm_max_map_count.sh # 関数を外部ファイルから読み込む

# Elasticsearchサービスの起動
sudo -i service elasticsearch start

# Kibanaサービスの起動
sudo -i service kibana start

# Logstashサービスの起動
sudo -i service logstash start

# Filebeatのセットアップと起動
sudo filebeat modules enable system
sudo filebeat modules enable nginx
sudo service filebeat start

# Metricbeatのセットアップと起動
sudo metricbeat modules enable system
sudo metricbeat modules enable nginx
sudo metricbeat modules enable elasticsearch-xpack
sudo metricbeat modules enable kibana-xpack
sudo metricbeat modules enable logstash-xpack
sudo service metricbeat start

# Packetbeatサービスの起動
sudo service packetbeat start
