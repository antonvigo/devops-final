#!/bin/bash

# ====> Alertmanager installation
cd ~/tmp
wget https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz
tar xvzf alertmanager-*.tar.gz
cd alertmanager-*/
cp alertmanager /usr/local/bin
mkdir -p /etc/alertmanager /var/lib/alertmanager
cp alertmanager.yml /etc/alertmanager
cd ..
useradd --no-create-home --home-dir / --shell /bin/false alertmanager
chown -R alertmanager:alertmanager /var/lib/alertmanager