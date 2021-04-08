#!/bin/bash
#Assumes the required files are sitting in home directory
#prometheus.yml, prometheus.conf, node_exporter.service
cd ~
mkdir Prometheus
cd Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
tar xvzf prometheus-2.26.0.linux-amd64.tar.gz
sudo useradd -rs /bin/false prometheus
cd prometheus-2.26.0.linux-amd64
sudo rm prometheus.yml
sudo cp prometheus promtool /usr/local/bin

sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo mkdir /etc/prometheus
cd ~
sudo cp prometheus.yml Prometheus/prometheus-2.26.0.linux-amd64
cd Prometheus/prometheus-2.26.0.linux-amd64
sudo cp -R consoles/ console_libraries/ prometheus.yml /etc/prometheus
sudo mkdir -p data/prometheus
sudo chown -R prometheus:prometheus data/prometheus /etc/prometheus/*
cd ~
sudo cp prometheus.service /lib/systemd/system
#Add test to see if nginx installed possibly, also probably not needed
sudo apt-get install nginx
sudo cp prometheus.conf /etc/nginx/conf.d
sudo apt-get install apache2-utils
cd /etc/prometheus
sudo htpasswd -c .credentials admin
#will get input from user
sudo apt-get install gnutls-bin
cd /etc/ssl
sudo mkdir prometheus
sudo certtool --generate-privkey --outfile prometheus-private-key.pem

sudo certtool --generate-self-signed --load-privkey prometheus-private-key.pem --outfile prometheus-cert.pem

cd ~/Prometheus
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
tar xvzf node_exporter-1.1.2.linux-amd64.tar.gz
cd node_exporter-1.1.2.linux-amd64
sudo cp node_exporter /usr/local/bin
sudo useradd -rs /bin/false node_exporter
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
cd ~
sudo cp node_exporter.service /lib/systemd/system

sudo systemctl daemon-reload
sudo systemctl restart nginx
sudo systemctl restart prometheus
sudo systemctl start node_exporter

#Grafana
sudo wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

sudo apt-get update
sudo apt-get install grafana
sudo systemctl start grafana-server
#this will allow anon access by default lol







