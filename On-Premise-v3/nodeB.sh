#!/bin/bash

# /etc/hosts に追加するエントリーを更新または追加する関数
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
update_or_add_to_hosts "10.252.0.239" "node-C"

# Elasticsearchの設定ファイルを更新
elasticsearch_config_file="/etc/elasticsearch/elasticsearch.yml"

sudo truncate -s 0 "$elasticsearch_config_file"

echo "cluster.name: my-cluster02
node.name: node-B
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
discovery.seed_hosts: [\"10.252.0.246\", \"10.252.0.201\", \"10.252.0.239\"]
cluster.initial_master_nodes: [\"node-A\", \"node-B\", \"node-C\"]
xpack.license.self_generated.type: basic
xpack.monitoring.collection.enabled: true" | sudo tee "$elasticsearch_config_file" > /dev/null

echo "Updated Elasticsearch configuration in $elasticsearch_config_file"


# Kibanaの設定ファイルを更新
kibana_config_file="/etc/kibana/kibana.yml"

sudo truncate -s 0 "$kibana_config_file"

echo "server.port: 5601
server.host: \"0.0.0.0\"
server.name: \"kibana-A\"
elasticsearch.hosts: [\"http://localhost:9200\"]" | sudo tee "$kibana_config_file" > /dev/null

echo "Updated Kibana configuration in $kibana_config_file"


# Logstashの設定ファイルを更新
logstash_config_file="/etc/logstash/logstash.yml"

sudo truncate -s 0 "$logstash_config_file"

echo "path.data: /var/lib/logstash
pipeline.id: main
path.logs: /var/log/logstash
xpack.monitoring.elasticsearch.hosts: \"http://localhost:9200\"" | sudo tee "$logstash_config_file" > /dev/null

echo "Updated Logstash configuration in $logstash_config_file"


echo "Updated Packetbeat configuration in $packetbeat_config_file"

# Logstashの新しいパイプライン設定ファイルを作成
logstash_pipeline_file="/etc/logstash/conf.d/default-pipeline.conf"

# 既存の設定があれば削除
sudo rm -f "$logstash_pipeline_file"

# 新しい設定を追加
echo "input {
    beats {
        port => \"5044\"
    }
}

output {
    elasticsearch {
        hosts => [ \"localhost:9200\" ]
    }
}" | sudo tee "$logstash_pipeline_file" > /dev/null

echo "Created new Logstash pipeline configuration in $logstash_pipeline_file"


# Filebeatの設定ファイルを更新
filebeat_config_file="/etc/filebeat/filebeat.yml"

sudo truncate -s 0 "$filebeat_config_file"

echo "filebeat.inputs:
- type: filestream
  id: my-filestream-id
  enabled: false
  paths:
    - /var/log/*.log

filebeat.config.modules:
  path: \${path.config}/modules.d/*.yml
  reload.enabled: false

setup.template.settings:
  index.number_of_shards: 1

setup.kibana:
  host: \"localhost:5601\"

output.elasticsearch:
  hosts: [\"localhost:9200\"]
output.logstash:
  hosts: [\"localhost:5044\"]

processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~

xpack.monitoring.enabled: true
http.enabled: true
http.host: 0.0.0.0
http.port: 5066" | sudo tee "$filebeat_config_file" > /dev/null

echo "Updated Filebeat configuration in $filebeat_config_file"



# Metricbeatの設定ファイルを更新
metricbeat_config_file="/etc/metricbeat/metricbeat.yml"

sudo truncate -s 0 "$metricbeat_config_file"

echo "metricbeat.config.modules:
  path: \${path.config}/modules.d/*.yml
  reload.enabled: false

setup.template.settings:
  index.number_of_shards: 1
  index.codec: best_compression

setup.kibana:
  host: \"localhost:5601\"

output.elasticsearch:
  hosts: [\"localhost:9200\"]
output.logstash:
  hosts: [\"localhost:5044\"]

processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~

xpack.monitoring.enabled: true" | sudo tee "$metricbeat_config_file" > /dev/null

echo "Updated Metricbeat configuration in $metricbeat_config_file"

# Packetbeatの設定ファイルを更新
packetbeat_config_file="/etc/packetbeat/packetbeat.yml"

sudo truncate -s 0 "$packetbeat_config_file"

echo "packetbeat.interfaces.device: any

packetbeat.interfaces.internal_networks:
  - private

packetbeat.flows:
  timeout: 30s
  period: 10s

packetbeat.protocols:
- type: icmp
  enabled: true
- type: amqp
  ports: [5672]
- type: cassandra
  ports: [9042]
- type: dhcpv4
  ports: [67, 68]
- type: dns
  ports: [53]
- type: http
  ports: [80, 8080, 8000, 5000, 8002]
- type: memcache
  ports: [11211]
- type: pgsql
  ports: [5432]
- type: redis
  ports: [6379]
- type: thrift
  ports: [9090]
- type: mongodb
  ports: [27017]
- type: nfs
  ports: [2049]
- type: tls
  ports:
    - 443   # HTTPS
    - 993   # IMAPS
    - 995   # POP3S
    - 5223  # XMPP over SSL
    - 8443
    - 8883  # Secure MQTT
    - 9243  # Elasticsearch
- type: sip
  ports: [5060]

setup.template.settings:
  index.number_of_shards: 1

setup.kibana:
  host: \"localhost:5601\"

output.elasticsearch:
  hosts: [\"localhost:9200\"]
output.logstash:
  hosts: [\"localhost:5044\"]

processors:
  - if.contains.tags: forwarded
    then:
      - drop_fields:
          fields: [host]
    else:
      - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - detect_mime_type:
      field: http.request.body.content
      target: http.request.mime_type
  - detect_mime_type:
      field: http.response.body.content
      target: http.response.mime_type

xpack.monitoring.enabled: true" | sudo tee "$packetbeat_config_file" > /dev/null

echo "Updated Packetbeat configuration in $packetbeat_config_file"
