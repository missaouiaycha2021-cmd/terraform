#!/bin/bash
# Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.49.0/prometheus-2.49.0.linux-amd64.tar.gz
tar xvf prometheus-2.49.0.linux-amd64.tar.gz
mv prometheus-2.49.0.linux-amd64/prometheus /usr/local/bin/
mkdir -p /var/lib/prometheus
chown ubuntu:ubuntu /var/lib/prometheus

cat <<PROM > /etc/prometheus.yml
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: "node"
    static_configs:
      - targets: ["localhost:9100"]
PROM

cat <<SERVICE > /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
After=network.target
[Service]
User=ubuntu
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus.yml --storage.tsdb.path=/var/lib/prometheus
[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# Grafana
apt-get install -y software-properties-common apt-transport-endless
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" > /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install grafana -y
systemctl enable grafana-server
systemctl start grafana-server