#!/bin/bash

# Elasticsearch サービスの停止
sudo service elasticsearch stop

# Kibana サービスの停止
sudo service kibana stop

# Logstash サービスの停止
sudo service logstash stop

# Filebeat サービスの停止
sudo service filebeat stop

# Metricbeat サービスの停止
sudo service metricbeat stop

# Packetbeat サービスの停止
sudo service packetbeat stop

# echo "All services have been stopped."

