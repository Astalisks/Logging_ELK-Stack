#!/bin/bash

# /etc/hosts に追加するエントリー
function update_or_add_to_hosts {
    local ip=$1
    local name=$2
    local file="/etc/hosts"

    # /etc/hostsにホスト名が存在するかどうかをgrepでチェック
    if grep -q " $name" "$file"; then
        # ホスト名が存在する場合は、IPアドレスを更新
        sudo sed -i "s/.* $name/$ip $name/" "$file"
        echo "Updated $name in $file"
    else
        # ホスト名が存在しない場合は、新しく追加
        echo "$ip $name" | sudo tee -a "$file" > /dev/null
        echo "Added $name to $file"
    fi
}

# 各ノードに対して関数を呼び出し
update_or_add_to_hosts "10.252.0.206" "node-A"
update_or_add_to_hosts "10.252.0.208" "node-B"
update_or_add_to_hosts "10.252.0.234" "node-C"

# Elasticsearchの設定ファイルの編集
sudo sed -i 's/#cluster.name: my-application/cluster.name: my-cluster02/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#node.name: node-1/node.name: node-C/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#discovery.seed_hosts: \["host1", "host2"\]/discovery.seed_hosts: \["10.252.0.246", "10.252.0.201", "10.252.0.239"\]/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#cluster.initial_master_nodes: \["node-1", "node-2"\]/cluster.initial_master_nodes: \["node-A", "node-B", "node-C"\]/' /etc/elasticsearch/elasticsearch.yml
