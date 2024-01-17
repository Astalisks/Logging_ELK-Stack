#!/bin/bash

# Elasticsearchの設定ファイルを編集
sudo sed -i 's/#cluster.name: my-application/cluster.name: my-cluster01/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#node.name: node-1/node.name: node-3/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's|path.data: /var/lib/elasticsearch|path.data: /var/lib/elasticsearch01|' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's|path.logs: /var/log/elasticsearch|path.logs: /var/log/elasticsearch01|' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#discovery.seed_hosts: \["host1", "host2"\]/discovery.seed_hosts: \["node-1", "node-2", "node-3"\]/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#cluster.initial_master_nodes: \["node-1", "node-2"\]/cluster.initial_master_nodes: \["node-1", "node-2", "node-3"\]/' /etc/elasticsearch/elasticsearch.yml
