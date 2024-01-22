#!/bin/bash


sudo apt-get update
sudo apt-get install -y curl nginx

# Elasticsearchの公開GPGキーをAPTにインポート
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install -y apt-transport-https
sudo apt-get update
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list

# /etc/hosts に追加するエントリー
# 関数定義: 特定の行が/etc/hostsに存在するかどうかをチェック
function add_if_not_exists {
    local ip=$1
    local name=$2
    local file="/etc/hosts"

    # /etc/hostsに行が存在するかどうかをgrepでチェック
    if ! grep -q "$ip $name" "$file"; then
        echo "$ip $name" | sudo tee -a "$file" > /dev/null
        echo "Added $name to $file"
    else
        echo "$name is already in $file"
    fi
}

# 各ノードについて関数を呼び出し
add_if_not_exists "10.252.0.206" "node-A"
add_if_not_exists "10.252.0.208" "node-B"
add_if_not_exists "10.252.0.234" "node-C"


# ソースリストを追加した後にパッケージリストを更新
sudo apt-get update

# Elasticsearchサービスの起動の際は最大vmの変更が推奨
# 設定する値
desired_value=262144

# 現在のvm.max_map_countの値を取得
current_value=$(sysctl -n vm.max_map_count)

# 現在の値と目的の値を比較
if [ "$current_value" != "$desired_value" ]; then
    # 値が異なる場合は、/etc/sysctl.confに設定を追加
    echo "vm.max_map_count=$desired_value" | sudo tee -a /etc/sysctl.conf
    # システム設定を更新
    sudo sysctl -p
    echo "vm.max_map_count has been updated to $desired_value"
else
    echo "vm.max_map_count is already set to $desired_value"
fi

sudo apt-get update

# Elasticsearch setup
sudo apt-get install -y elasticsearch
# Elasticsearchの設定ファイルを編集
sudo sed -i 's/#cluster.name: my-application/cluster.name: my-cluster02/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#node.name: node-1/node.name: node-C/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#network.host: 192.168.0.1/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#discovery.seed_hosts: \["host1", "host2"\]/discovery.seed_hosts: \["10.252.0.246", "10.252.0.201", "10.252.0.234"\]/' /etc/elasticsearch/elasticsearch.yml
sudo sed -i 's/#cluster.initial_master_nodes: \["node-1", "node-2"\]/cluster.initial_master_nodes: \["node-A", "node-B", "node-C"\]/' /etc/elasticsearch/elasticsearch.yml
# sudo /bin/systemctl daemon-reload
# sudo /bin/systemctl enable elasticsearch.service

# 起動
# sudo systemctl start elasticsearch.service
sudo -i service elasticsearch start

# ログ確認
# sudo journalctl -f
# sudo journalctl --unit elasticsearch


# Kibana setup
sudo apt-get update
sudo apt-get install -y kibana

sudo -i service kibana start


# Logstash setup
sudo apt-get update
sudo apt-get install -y logstash
sudo -i service logstash start

# Filebeat setup
sudo apt-get update
sudo apt-get install -y filebeat
sudo filebeat modules enable system
sudo filebeat modules enable nginx
# sudo filebeat setup
sudo service filebeat start

# Metricbeat setup
sudo apt-get update
sudo apt-get install -y metricbeat
sudo metricbeat modules enable system
sudo metricbeat modules enable nginx
sudo metricbeat modules enable elasticsearch-xpack
sudo metricbeat modules enable kibana-xpack
sudo metricbeat modules enable logstash-xpack
# sudo metricbeat setup
sudo service metricbeat start

# Packetbeat setup
sudo apt-get update
sudo apt-get install -y packetbeat

sudo service packetbeat start


# 不要なパッケージの削除
sudo apt autoremove -y
sudo apt clean -y