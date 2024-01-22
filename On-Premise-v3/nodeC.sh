#!/bin/bash

# /etc/hosts に追加するエントリー
.entry_etc_hosts # 関数を外部ファイルから読み込む
add_if_not_exists "10.252.0.206" "node-A"
add_if_not_exists "10.252.0.208" "node-B"
add_if_not_exists "10.252.0.239" "node-C"

# Elasticsearchの設定ファイルの編集
sudo sed -i 's/#cluster.name: my-application/cluster.name: my-cluster02/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#node.name: node-1/node.name: node-C/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#discovery.seed_hosts: \["host1", "host2"\]/discovery.seed_hosts: \["10.252.0.246", "10.252.0.201", "10.252.0.239"\]/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#cluster.initial_master_nodes: \["node-1", "node-2"\]/cluster.initial_master_nodes: \["node-A", "node-B", "node-C"\]/' /etc/elasticsearch/elasticsearch.yml
