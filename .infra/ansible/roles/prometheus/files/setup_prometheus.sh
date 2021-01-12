#!/bin/bash

# ====> Prometheus installation
cd ~/tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.21.0/prometheus-2.21.0.linux-amd64.tar.gz
tar xvzf prometheus-*.tar.gz
cd prometheus-*/
cp prometheus promtool /usr/local/bin
mkdir /etc/prometheus /var/lib/prometheus
cp prometheus.yml /etc/prometheus
cd ..
useradd --no-create-home --home-dir / --shell /bin/false prometheus
chown -R prometheus:prometheus /var/lib/prometheus