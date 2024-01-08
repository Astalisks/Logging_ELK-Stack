#!/bin/bash
# Elasticsearch setup
sudo apt update
sudo apt install elasticsearch
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
# Kibana setup
sudo apt install kibana
sudo systemctl enable kibana.service
# Logstash setup
sudo apt install logstash
# Filebeat setup
sudo apt install filebeat
sudo filebeat modules enable system
sudo filebeat setup
# Metricbeat setup
sudo apt install metricbeat
sudo metricbeat modules enable system
