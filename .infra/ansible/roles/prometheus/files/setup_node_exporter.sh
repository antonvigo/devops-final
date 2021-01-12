#!/bin/bash

# ====> Node Exporter installation
cd ~/tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
tar xvzf node_exporter-*.tar.gz
cd node_exporter-*/
cp node_exporter /usr/local/bin
cd ..
useradd --no-create-home --home-dir / --shell /bin/false node_exporter