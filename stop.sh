#!/bin/bash
# Stop Metricbeat
sudo systemctl stop metricbeat.service
# Stop Filebeat
sudo systemctl stop filebeat.service
# Stop Logstash
sudo systemctl stop logstash.service
# Stop Kibana
sudo systemctl stop kibana.service
# Stop Elasticsearch
sudo systemctl stop elasticsearch.service
