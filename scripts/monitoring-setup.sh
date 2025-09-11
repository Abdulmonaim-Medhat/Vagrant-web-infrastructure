#!/bin/bash

echo "=== Monitoring Stack Setup (Prometheus + Grafana) ==="

# Update system packages
apt-get update -y

# Create monitoring user
useradd --no-create-home --shell /bin/false prometheus
useradd --no-create-home --shell /bin/false grafana

# Install dependencies
apt-get install -y wget curl software-properties-common

echo "=== Installing Prometheus ==="

# Download and install Prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.40.0/prometheus-2.40.0.linux-amd64.tar.gz
tar xvf prometheus-2.40.0.linux-amd64.tar.gz

# Create directories
mkdir -p /etc/prometheus /var/lib/prometheus

# Copy binaries
cp prometheus-2.40.0.linux-amd64/prometheus /usr/local/bin/
cp prometheus-2.40.0.linux-amd64/promtool /usr/local/bin/

# Set permissions
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
chown -R prometheus:prometheus /etc/prometheus
chown -R prometheus:prometheus /var/lib/prometheus

# Copy configuration
cp /vagrant/config/prometheus/prometheus.yml /etc/prometheus/
chown prometheus:prometheus /etc/prometheus/prometheus.yml

# Create systemd service
cat > /etc/systemd/system/prometheus.service << 'PROM_SERVICE'
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries \
    --web.listen-address=0.0.0.0:9090 \
    --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
PROM_SERVICE

echo "=== Installing Grafana ==="

# Install Grafana
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" > /etc/apt/sources.list.d/grafana.list
apt-get update -y
apt-get install -y grafana

# Configure Grafana
cp /vagrant/config/grafana/grafana.ini /etc/grafana/ || echo "Using default Grafana config"

echo "=== Installing Node Exporter ==="

# Download and install Node Exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz
tar xvf node_exporter-1.5.0.linux-amd64.tar.gz
cp node_exporter-1.5.0.linux-amd64/node_exporter /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/node_exporter

# Create Node Exporter service
cat > /etc/systemd/system/node_exporter.service << 'NODE_SERVICE'
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
NODE_SERVICE

# Start all services
systemctl daemon-reload
systemctl start prometheus
systemctl start grafana-server
systemctl start node_exporter
systemctl enable prometheus
systemctl enable grafana-server
systemctl enable node_exporter

# Clean up
rm -rf /tmp/prometheus-* /tmp/node_exporter-*

echo "=== Monitoring Setup Completed ==="
echo "Prometheus: http://192.168.20.102:9090"
echo "Grafana: http://192.168.20.102:3000 (admin/admin)"
echo "Node Exporter: http://192.168.20.102:9100"
