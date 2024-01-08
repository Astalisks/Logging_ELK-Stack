#!/bin/bash
# Start Elasticsearch
sudo systemctl start elasticsearch.service
# Start Kibana
sudo systemctl start kibana.service
# Start Logstash
sudo systemctl start logstash.service
# Start Filebeat
sudo systemctl start filebeat.service
# Start Metricbeat
sudo systemctl start metricbeat.service
