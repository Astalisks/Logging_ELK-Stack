sudo metricbeat modules list

sudo nano /etc/elasticsearch/elasticsearch.yml

sudo git clone https://github.com/Astalisks/Logging_ELK-Stack.git


default-pipeline.conf
input {
    beats {
        port => "5044"
    }
}

output {
    elasticsearch {
        hosts => [ "localhost:9200" ]
    }
}
